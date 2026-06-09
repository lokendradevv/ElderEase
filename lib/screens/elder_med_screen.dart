import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/medication_provider.dart';
import '../services/firestore_service.dart';
import '../utils/date_formatter.dart';
import 'add_medicine_screen.dart';

class ElderMedScreen extends ConsumerWidget {
  const ElderMedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationsAsync = ref.watch(medicationProvider);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 120), // Push above the main screen nav bar
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMedicineScreen()),
            );
          },
          backgroundColor: AppTheme.primaryBlue,
          elevation: 8,
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Medicines',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDarkGray,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: medicationsAsync.when(
                  data: (medications) {
                    if (medications.isEmpty) {
                      return const Center(child: Text("No medications found. Add some using the + button.", style: TextStyle(color: AppTheme.textMuted)));
                    }
                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: medications.length,
                      padding: const EdgeInsets.only(bottom: 140), // Pad scroll content above bottom nav
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final med = medications[index];
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
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    med.name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textDarkGray,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_rounded, color: AppTheme.primaryBlue),
                                        onPressed: () async {
                                          final TimeOfDay? newTime = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (newTime != null && context.mounted) {
                                            final String formattedTime = newTime.format(context);
                                            final updatedMed = med.copyWith(time: formattedTime);
                                            await firestoreService.updateMedication(updatedMed);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                                        onPressed: () async {
                                          final bool? confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Delete Medicine'),
                                                content: Text('Are you sure you want to delete ${med.name}?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                  ),
                                                  TextButton(
                                                    child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                                                    onPressed: () => Navigator.of(context).pop(true),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          if (confirm == true) {
                                            await firestoreService.deleteMedication(med.id);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.medication_outlined, size: 18, color: AppTheme.textMuted),
                                  const SizedBox(width: 6),
                                  Text(med.dosage, style: const TextStyle(color: AppTheme.textMuted, fontSize: 16)),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.access_time_rounded, size: 18, color: AppTheme.textMuted),
                                  const SizedBox(width: 6),
                                  Text(med.time, style: const TextStyle(color: AppTheme.textMuted, fontSize: 16)),
                                ],
                              ),
                              if (med.startDate != null && med.endDate != null) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today_rounded, size: 16, color: AppTheme.primaryBlue),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${DateFormatter.formatOrdinalDate(med.startDate!)} - ${DateFormatter.formatOrdinalDate(med.endDate!)}',
                                      style: const TextStyle(color: AppTheme.primaryBlue, fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text("Firebase Error: ${error.toString()}", style: const TextStyle(color: AppTheme.errorRed))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
