import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../models/medication.dart';
import '../services/firestore_service.dart';
import '../utils/date_formatter.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final List<TimeOfDay> _selectedTimes = [TimeOfDay.now()];
  DateTimeRange? _selectedDateRange;

  Future<void> _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimes[index],
    );
    if (picked != null && picked != _selectedTimes[index]) {
      setState(() {
        _selectedTimes[index] = picked;
      });
    }
  }

  void _addTime() {
    if (_selectedTimes.length < 4) {
      setState(() {
        _selectedTimes.add(TimeOfDay.now());
      });
    }
  }

  void _removeTime(int index) {
    if (_selectedTimes.length > 1) {
      setState(() {
        _selectedTimes.removeAt(index);
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  Future<void> _saveMedicine() async {
    if (_nameController.text.isEmpty || _dosageController.text.isEmpty) return;
    
    try {
      for (int i = 0; i < _selectedTimes.length; i++) {
        final formattedTime = _selectedTimes[i].format(context);
        
        final newMed = Medication(
          id: '${DateTime.now().millisecondsSinceEpoch}_$i',
          name: _nameController.text,
          dosage: _dosageController.text,
          time: formattedTime,
          startDate: _selectedDateRange?.start,
          endDate: _selectedDateRange?.end,
        );
        
        await firestoreService.addMedication(newMed);
      }
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save to Firebase: \$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundOffWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textDarkGray),
        title: const Text('Add Medicine', style: TextStyle(color: AppTheme.textDarkGray, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Medicine Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textDarkGray)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppTheme.cardWhite,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  hintText: 'e.g., Lisinopril',
                ),
              ),
              const SizedBox(height: 24),
              const Text('Dosage', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textDarkGray)),
              const SizedBox(height: 8),
              TextField(
                controller: _dosageController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppTheme.cardWhite,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  hintText: 'e.g., 1 Pill',
                ),
              ),
              const SizedBox(height: 24),
              const Text('Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textDarkGray)),
              const SizedBox(height: 8),
              ..._selectedTimes.asMap().entries.map((entry) {
                final int index = entry.key;
                final TimeOfDay time = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectTime(context, index),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.cardWhite,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(time.format(context), style: const TextStyle(fontSize: 16, color: AppTheme.textDarkGray)),
                                const Icon(Icons.access_time_rounded, color: AppTheme.primaryBlue),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_selectedTimes.length > 1)
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline_rounded, color: AppTheme.errorRed),
                          onPressed: () => _removeTime(index),
                        ),
                    ],
                  ),
                );
              }),
              if (_selectedTimes.length < 4)
                TextButton.icon(
                  onPressed: _addTime,
                  icon: const Icon(Icons.add_rounded, color: AppTheme.primaryBlue),
                  label: const Text('Add another time', style: TextStyle(color: AppTheme.primaryBlue)),
                ),
              const SizedBox(height: 24),
              const Text('Timeline (Optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textDarkGray)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDateRange(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cardWhite,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDateRange == null
                            ? 'Select Duration'
                            : '${DateFormatter.formatOrdinalDate(_selectedDateRange!.start)} to ${DateFormatter.formatOrdinalDate(_selectedDateRange!.end)}',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedDateRange == null ? AppTheme.textMuted : AppTheme.textDarkGray,
                        ),
                      ),
                      const Icon(Icons.calendar_today_rounded, color: AppTheme.primaryBlue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveMedicine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  child: const Text('Save Medicine', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
