import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/openrouter_service.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../models/activity_log.dart';

import '../models/medication.dart';

class CameraScreen extends StatefulWidget {
  final Medication medication;

  const CameraScreen({super.key, required this.medication});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isVerifying = false;
  bool? _isVerified;
  String? _verificationReason;
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Camera init error: \$e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _captureAndVerify() async {
    if (!_isCameraInitialized || _controller == null) return;
    setState(() {
      _isVerifying = true;
      _verificationReason = null;
    });

    try {
      final XFile image = await _controller!.takePicture();
      final bytes = await image.readAsBytes();
      
      final (isVerified, reason) = await openRouterService.verifyMedicine(bytes, widget.medication.name);

      // Log the activity to Firestore
      final log = ActivityLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: isVerified ? 'Verified: ${widget.medication.name}' : 'Incorrect Med: ${widget.medication.name}',
        description: reason,
        timestamp: DateTime.now(),
        type: isVerified ? 'medication_taken' : 'emergency',
      );
      await firestoreService.addActivityLog(log);

      if (isVerified) {
        final updatedMed = widget.medication.copyWith(isCompleted: true);
        await firestoreService.updateMedication(updatedMed);

        // Notify LINE Bot backend
        try {
          final userId = authService.currentUserId;
          if (userId != null) {
            final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
            final caregiverLineId = userDoc.data()?['caregiverLineUserId'];

            await http.post(
              // Using 127.0.0.1 with ADB reverse port forwarding for physical devices
              Uri.parse('http://127.0.0.1:3000/api/notify/taken'), 
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'elderId': userId,
                'medicationName': widget.medication.name,
                'caregiverLineId': caregiverLineId,
              }),
            );
          }
        } catch (e) {
          debugPrint('Failed to notify LINE backend: $e');
        }
      }

      if (mounted) {
        setState(() {
          _isVerifying = false;
          _isVerified = isVerified;
          _verificationReason = reason;
        });
      }
    } catch (e) {
      debugPrint("Verification Error: \$e");
      if (mounted) {
        setState(() {
          _isVerifying = false;
          _isVerified = false;
          _verificationReason = "An unexpected error occurred: \$e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify ${widget.medication.name}'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isVerifying) ...[
                const CircularProgressIndicator(color: AppTheme.primaryBlue),
                const SizedBox(height: 24),
                Text(
                  'Analyzing image...',
                  style: theme.textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ] else if (_isVerified == true) ...[
                const Icon(Icons.check_circle, color: AppTheme.successGreen, size: 120),
                const SizedBox(height: 24),
                Text(
                  'Verified! Great Job!',
                  style: theme.textTheme.displayMedium?.copyWith(color: AppTheme.successGreen),
                  textAlign: TextAlign.center,
                ),
                if (_verificationReason != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _verificationReason!,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back home
                  },
                  child: const Text('Back to Home'),
                ),
              ] else if (_isVerified == false) ...[
                const Icon(Icons.cancel, color: AppTheme.errorRed, size: 120),
                const SizedBox(height: 24),
                Text(
                  'Warning: Incorrect Medicine',
                  style: theme.textTheme.displayMedium?.copyWith(color: AppTheme.errorRed),
                  textAlign: TextAlign.center,
                ),
                if (_verificationReason != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _verificationReason!,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isVerified = null;
                      _verificationReason = null;
                    });
                  },
                  child: const Text('Try Again'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to Home'),
                ),
              ] else ...[
                Container(
                  height: 300,
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.primaryBlue, width: 4),
                  ),
                  child: _isCameraInitialized && _controller != null
                      ? CameraPreview(_controller!)
                      : const Center(
                          child: CircularProgressIndicator(color: AppTheme.primaryBlue),
                        ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Please take a photo of your pill.',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _captureAndVerify,
                  icon: const Icon(Icons.camera),
                  label: const Text('Capture Image'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
