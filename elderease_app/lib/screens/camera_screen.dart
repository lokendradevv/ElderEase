import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:http/http.dart' as http;

class CameraScreen extends StatefulWidget {
  final String medicationName;

  const CameraScreen({super.key, required this.medicationName});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isVerifying = false;
  bool? _isVerified;

  void _simulateCaptureAndVerify() async {
    setState(() {
      _isVerifying = true;
    });

    try {
      // Stub API request
      await http.post(
        Uri.parse('http://10.0.2.2:3000/api/verify'), // Android Emulator Localhost
        headers: {'Content-Type': 'application/json'},
      );

      // Even if API fails (since backend isn't running), we simulate success for UI showcase
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isVerifying = false;
        _isVerified = true;
      });
    } catch (e) {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isVerifying = false;
        _isVerified = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify ${widget.medicationName}'),
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
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back home
                  },
                  child: const Text('Back to Home'),
                ),
              ] else ...[
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.primaryBlue, width: 4),
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt, size: 80, color: Colors.black45),
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
                  onPressed: _simulateCaptureAndVerify,
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
