import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/activity_log_provider.dart';
import '../models/activity_log.dart';

class ElderHistoryScreen extends ConsumerWidget {
  const ElderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityLogsAsync = ref.watch(activityLogProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'History',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDarkGray,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: activityLogsAsync.when(
                data: (logs) {
                  if (logs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No recent history. Your activity will appear here.",
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 140), // Pad scroll content above bottom nav
                    itemCount: logs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return _buildLogCard(log);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text(
                    "Error loading history: \${error.toString()}",
                    style: const TextStyle(color: AppTheme.errorRed),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogCard(ActivityLog log) {
    IconData iconData;
    Color iconColor;
    Color bgColor;

    switch (log.type) {
      case 'medication_taken':
        iconData = Icons.check_circle_outline_rounded;
        iconColor = AppTheme.successGreen;
        bgColor = const Color(0xFFF0FDF4); // Light green
        break;
      case 'medication_missed':
        iconData = Icons.cancel_outlined;
        iconColor = AppTheme.errorRed;
        bgColor = const Color(0xFFFEF2F2); // Light red
        break;
      case 'emergency':
        iconData = Icons.warning_amber_rounded;
        iconColor = AppTheme.errorRed;
        bgColor = const Color(0xFFFEF2F2);
        break;
      default:
        iconData = Icons.info_outline_rounded;
        iconColor = AppTheme.primaryBlue;
        bgColor = const Color(0xFFEFF6FF); // Light blue
        break;
    }

    final formattedTime = _formatTimestamp(log.timestamp);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        log.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDarkGray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formattedTime,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  log.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    // Format time (e.g. "10:30 AM")
    String period = timestamp.hour >= 12 ? 'PM' : 'AM';
    int hour = timestamp.hour > 12 ? timestamp.hour - 12 : (timestamp.hour == 0 ? 12 : timestamp.hour);
    String minute = timestamp.minute.toString().padLeft(2, '0');
    String timeStr = '$hour:$minute $period';

    if (difference.inDays == 0 && now.day == timestamp.day) {
      return 'Today, $timeStr';
    } else if (difference.inDays == 1 || (difference.inDays == 0 && now.day != timestamp.day)) {
      return 'Yesterday, $timeStr';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
