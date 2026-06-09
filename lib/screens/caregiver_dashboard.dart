import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CaregiverDashboard extends StatelessWidget {
  const CaregiverDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        backgroundColor: Colors.indigo.shade800,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Overview',
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          _buildPatientCard(
            context: context,
            name: 'Dad',
            lastUpdated: 'Just now',
            status: 'All good',
            statusColor: AppTheme.successGreen,
            medications: [
              {'name': 'Aspirin', 'time': '08:00 AM', 'taken': true},
              {'name': 'Vitamin C', 'time': '12:00 PM', 'taken': false},
            ]
          ),
          const SizedBox(height: 16),
          _buildPatientCard(
            context: context,
            name: 'Mom',
            lastUpdated: '1 hour ago',
            status: 'Missed Dose',
            statusColor: AppTheme.errorRed,
            medications: [
              {'name': 'Heart Meds', 'time': '07:00 AM', 'taken': false},
            ]
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.indigo.shade800,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPatientCard({
    required BuildContext context,
    required String name,
    required String lastUpdated,
    required String status,
    required Color statusColor,
    required List<Map<String, dynamic>> medications,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: theme.textTheme.displayMedium?.copyWith(fontSize: 24),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: $lastUpdated',
              style: theme.textTheme.bodyMedium,
            ),
            const Divider(height: 32, thickness: 1),
            Text(
              "Today's Schedule",
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...medications.map((med) => _buildMedRow(med['name'], med['time'], med['taken'])),
          ],
        ),
      ),
    );
  }

  Widget _buildMedRow(String name, String time, bool taken) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                taken ? Icons.check_circle : Icons.radio_button_unchecked,
                color: taken ? AppTheme.successGreen : Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(time, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        ],
      ),
    );
  }
}
