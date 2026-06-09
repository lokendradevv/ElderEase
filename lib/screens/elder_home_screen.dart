import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import 'camera_screen.dart';
import '../models/medication.dart';
import '../providers/medication_provider.dart';
import '../providers/user_provider.dart';

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();
  void setDate(DateTime date) => state = date;
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

String _formatDate(DateTime date) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

int _timeToMinutes(String timeStr) {
  try {
    final parts = timeStr.split(' ');
    if (parts.length != 2) return 0;
    final timeParts = parts[0].split(':');
    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    
    if (parts[1].toUpperCase() == 'PM' && hour != 12) {
      hour += 12;
    } else if (parts[1].toUpperCase() == 'AM' && hour == 12) {
      hour = 0;
    }
    return hour * 60 + minute;
  } catch (e) {
    return 0;
  }
}

String _getGreeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}

class ElderHomeScreen extends ConsumerWidget {
  const ElderHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final medicationsAsync = ref.watch(medicationProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final userProfileAsync = ref.watch(userProvider);
    
    final userName = userProfileAsync.value?.name ?? 'Elder';
    final greeting = _getGreeting();

    // Using a refined blue that closely matches the new design
    const alertBlueBg = Color(0xFFEFF6FF);

    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$greeting, $userName 👋',
                            style: theme.textTheme.displayMedium?.copyWith(fontSize: 28),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Stay on track, stay healthy.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 16,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_none_rounded,
                          size: 32,
                          color: AppTheme.textDarkGray,
                        ),
                        Positioned(
                          top: 2,
                          right: 4,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: AppTheme.errorRed,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.backgroundOffWhite, width: 2),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Alert Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: alertBlueBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.medication_rounded, color: Colors.white, size: 28),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You have ${medicationsAsync.value?.length ?? 0} medications today',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDarkGray,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Grandpa! Grandma! take care',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppTheme.textDarkGray),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today\'s Schedule',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDarkGray,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppTheme.primaryBlue,
                                  onPrimary: Colors.white,
                                  onSurface: AppTheme.textDarkGray,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null) {
                          ref.read(selectedDateProvider.notifier).setDate(pickedDate);
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, color: AppTheme.primaryBlue, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(selectedDate),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Meds
                medicationsAsync.when(
                  data: (medications) {
                    if (medications.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text('No medications scheduled today.', style: TextStyle(color: AppTheme.textMuted, fontSize: 16)),
                        ),
                      );
                    }
                    
                    final sortedMeds = List.of(medications);
                    sortedMeds.sort((a, b) {
                      if (a.isCompleted && !b.isCompleted) return 1;
                      if (!a.isCompleted && b.isCompleted) return -1;
                      return _timeToMinutes(a.time).compareTo(_timeToMinutes(b.time));
                    });

                    return Column(
                      children: sortedMeds.asMap().entries.map((entry) {
                        final index = entry.key;
                        final med = entry.value;
                        // For demo, first item is active, rest are upcoming
                        final isFirst = index == 0;
                        
                        return Column(
                          children: [
                            isFirst 
                              ? _buildActiveCard(context, med)
                              : _buildUpcomingCard(context, med),
                            if (index < medications.length - 1) const SizedBox(height: 20),
                          ],
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, stack) => const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: Text('Failed to load meds. Check Firebase.', style: TextStyle(color: AppTheme.errorRed))),
                  ),
                ),

                const SizedBox(height: 120), // Bottom padding for navbar
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Active / Next Medicine Card
  Widget _buildActiveCard(BuildContext context, Medication med) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
                med.time,
                style: const TextStyle(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              if (med.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppTheme.successGreen, size: 16),
                      const SizedBox(width: 4),
                      const Text('Already Taken', style: TextStyle(color: AppTheme.successGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              else
                const Icon(Icons.notifications_none_rounded, color: AppTheme.primaryBlue, size: 26),
            ],
          ),
          const SizedBox(height: 16),
          Text(med.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textDarkGray)),
          const SizedBox(height: 6),
          Text(med.dosage, style: const TextStyle(fontSize: 16, color: AppTheme.textMuted)),
          const SizedBox(height: 24),
          // Take Now Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: med.isCompleted ? null : () {
                final now = TimeOfDay.now();
                final currentMinutes = now.hour * 60 + now.minute;
                final scheduledMinutes = _timeToMinutes(med.time);
                
                if (scheduledMinutes - currentMinutes > 5) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Grandma Grandpa wait for the exact time', style: TextStyle(fontSize: 16)),
                      backgroundColor: AppTheme.errorRed,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.all(20),
                    ),
                  );
                  return;
                }

                Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(medication: med)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: med.isCompleted ? AppTheme.textMuted.withValues(alpha: 0.3) : AppTheme.primaryBlue,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                )
              ),
              child: Row(
                children: [
                  Icon(med.isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded, color: med.isCompleted ? AppTheme.textDarkGray : Colors.white, size: 24),
                  Expanded(
                    child: Center(
                      child: Text(med.isCompleted ? 'Completed' : 'Take Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: med.isCompleted ? AppTheme.textDarkGray : Colors.white)),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: med.isCompleted ? AppTheme.textDarkGray : Colors.white, size: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Upcoming Medicine Card
  Widget _buildUpcomingCard(BuildContext context, Medication med) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                med.time,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              if (med.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppTheme.successGreen, size: 16),
                      const SizedBox(width: 4),
                      const Text('Already Taken', style: TextStyle(color: AppTheme.successGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              else
                const Icon(Icons.access_time_rounded, color: AppTheme.textMuted, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Text(med.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDarkGray)),
          const SizedBox(height: 4),
          Text(med.dosage, style: const TextStyle(fontSize: 16, color: AppTheme.textMuted)),
          const SizedBox(height: 16),
          // Upcoming Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_outlined, color: AppTheme.textMuted.withValues(alpha: 0.8), size: 16),
                const SizedBox(width: 6),
                Text('Upcoming', style: TextStyle(color: AppTheme.textMuted.withValues(alpha: 0.8), fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
