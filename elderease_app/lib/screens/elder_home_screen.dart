import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'camera_screen.dart';

class ElderHomeScreen extends StatelessWidget {
  const ElderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Good Morning, Loki',
                style: theme.textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'You have 2 medications today',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 32),
              
              // List
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildCompletedCard(context, 'Heart Meds', '07:00 AM', '1 Pill'),
                    const SizedBox(height: 20),
                    _buildActiveCard(context, 'Aspirin', '08:00 AM', '1 Pill'),
                    const SizedBox(height: 20),
                    _buildUpcomingCard(context, 'Vitamin C', '12:00 PM', '1 Pill'),
                    const SizedBox(height: 120), // Bottom padding for navbar
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Active / Next Medicine Card
  Widget _buildActiveCard(BuildContext context, String name, String time, String dose) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Icon(Icons.notifications_active_outlined, color: AppTheme.primaryBlue),
            ],
          ),
          const SizedBox(height: 16),
          Text(name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textDarkGray)),
          const SizedBox(height: 4),
          Text(dose, style: const TextStyle(fontSize: 18, color: AppTheme.textMuted)),
          const SizedBox(height: 24),
          // Take Now Button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                colors: [AppTheme.primaryBlueLight, AppTheme.primaryBlue],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(medicationName: name)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text('Take Now', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // Completed Medicine Card
  Widget _buildCompletedCard(BuildContext context, String name, String time, String dose) {
    return Opacity(
      opacity: 0.6,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const Icon(Icons.check_circle_outline, color: AppTheme.successGreen),
              ],
            ),
            const SizedBox(height: 12),
            Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, decoration: TextDecoration.lineThrough, color: AppTheme.textMuted)),
            const SizedBox(height: 4),
            Text(dose, style: const TextStyle(fontSize: 16, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }

  // Upcoming Medicine Card
  Widget _buildUpcomingCard(BuildContext context, String name, String time, String dose) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Light Grey
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const Icon(Icons.access_time, color: AppTheme.textMuted, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppTheme.textDarkGray)),
          const SizedBox(height: 4),
          Text(dose, style: const TextStyle(fontSize: 16, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}
