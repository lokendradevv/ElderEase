import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/medication_provider.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/user_profile.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/notification_service.dart';
import 'privacy_security_screen.dart';

class NotificationsEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void set(bool val) => state = val;
}
final notificationsEnabledProvider = NotifierProvider<NotificationsEnabledNotifier, bool>(NotificationsEnabledNotifier.new);

class RemindersEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void set(bool val) => state = val;
}
final remindersEnabledProvider = NotifierProvider<RemindersEnabledNotifier, bool>(RemindersEnabledNotifier.new);

class ElderProfileScreen extends ConsumerWidget {
  const ElderProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationsCount = ref.watch(medicationProvider).value?.length ?? 0;
    final userProfileAsync = ref.watch(userProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final remindersEnabled = ref.watch(remindersEnabledProvider);
    final userProfile = userProfileAsync.value;

    final name = userProfile?.name ?? 'Loading...';
    final age = userProfile?.age ?? 'N/A';
    final bloodGroup = userProfile?.bloodGroup ?? 'N/A';
    final caregiverName = userProfile?.caregiverName ?? 'Not Assigned';

    final l10n = AppLocalizations.of(context);
    final roleText = userProfile?.role == 'elder' ? l10n.translate('profile_role_elder') : l10n.translate('profile_role_caregiver');

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 20.0, bottom: 140.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translate('profile_title'),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDarkGray,
              ),
            ),
            const SizedBox(height: 24),
            
            // User Info Card
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF60A5FA), AppTheme.primaryBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(color: AppTheme.primaryBlue.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 8)),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.person_rounded, size: 40, color: AppTheme.primaryBlue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text(roleText, style: const TextStyle(fontSize: 16, color: Colors.white70)),
                      ],
                    ),
                  ),
                    GestureDetector(
                      onTap: () {
                        final profile = userProfile ?? UserProfile(
                          id: authService.currentUserId ?? 'unknown',
                          name: 'Elder',
                          role: 'elder',
                        );
                        _showEditProfileDialog(context, profile);
                      },
                    child: const Icon(Icons.edit_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Info Section
            Row(
              children: [
                _buildQuickInfoCard(l10n.translate('profile_quick_age'), age, Icons.cake_outlined),
                const SizedBox(width: 16),
                _buildQuickInfoCard(l10n.translate('profile_quick_meds'), '$medicationsCount', Icons.medication_outlined),
                const SizedBox(width: 16),
                _buildQuickInfoCard(l10n.translate('profile_quick_blood'), bloodGroup, Icons.bloodtype_outlined),
              ],
            ),
            const SizedBox(height: 32),

            // Caregiver Section
            Text(l10n.translate('profile_caregiver_title'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDarkGray)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2), width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.favorite_rounded, color: AppTheme.primaryBlue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(caregiverName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textDarkGray)),
                            const SizedBox(height: 4),
                            Text(userProfile?.caregiverLineUserId != null && userProfile!.caregiverLineUserId!.isNotEmpty ? 'LINE Connected' : l10n.translate('profile_caregiver_pending'), style: const TextStyle(fontSize: 14, color: AppTheme.successGreen, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        final profile = userProfile ?? UserProfile(
                          id: authService.currentUserId ?? 'unknown',
                          name: 'Elder',
                          role: 'elder',
                        );
                        _showManageCaregiverDialog(context, profile);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.primaryBlue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(l10n.translate('profile_btn_manage_caregiver'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Settings Section
            Text(l10n.translate('profile_settings_title'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDarkGray)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardWhite,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  _buildToggleSettingItem(Icons.notifications_none_rounded, l10n.translate('profile_settings_notifications'), notificationsEnabled, (val) {
                    ref.read(notificationsEnabledProvider.notifier).set(val);
                    if (!val) notificationService.cancelAll();
                  }),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: Color(0xFFF1F5F9)),
                  _buildToggleSettingItem(Icons.alarm_rounded, l10n.translate('profile_settings_reminders'), remindersEnabled, (val) {
                    ref.read(remindersEnabledProvider.notifier).set(val);
                  }),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: Color(0xFFF1F5F9)),
                  _buildSettingItem(Icons.lock_outline_rounded, l10n.translate('profile_settings_privacy'), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacySecurityScreen()),
                    );
                  }),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: Color(0xFFF1F5F9)),
                  _buildSettingItem(Icons.language_rounded, l10n.translate('profile_settings_language'), () {
                    _showLanguageDialog(context, ref);
                  }),
                  const Divider(height: 1, indent: 56, endIndent: 20, color: Color(0xFFF1F5F9)),
                  _buildSettingItem(Icons.send_rounded, 'Send Test LINE Notification', () async {
                    if (userProfile?.caregiverLineUserId == null || userProfile!.caregiverLineUserId!.isEmpty) {
                      final profile = userProfile ?? UserProfile(
                        id: authService.currentUserId ?? 'unknown',
                        name: 'Elder',
                        role: 'elder',
                      );
                      _showManageCaregiverDialog(context, profile);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please configure a Caregiver LINE User ID first')));
                      return;
                    }
                    try {
                      final response = await http.post(
                        Uri.parse('http://127.0.0.1:3000/api/notify/test'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({
                          'elderId': authService.currentUserId,
                          'caregiverLineId': userProfile!.caregiverLineUserId,
                        }),
                      );
                      if (context.mounted) {
                        if (response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test notification sent successfully!')));
                        } else {
                          String errorMsg = 'Unknown error';
                          try {
                            errorMsg = jsonDecode(response.body)['error'] ?? response.body;
                          } catch (_) {
                            errorMsg = response.body;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $errorMsg')));
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    }
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Emergency Section
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.local_hospital_rounded, color: AppTheme.errorRed),
                label: Text(l10n.translate('profile_btn_emergency'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.errorRed)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorRed.withValues(alpha: 0.1),
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Logout Section
            Center(
              child: TextButton(
                onPressed: () async {
                  await authService.signOut();
                  if (context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                child: Text(l10n.translate('profile_btn_logout'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textMuted)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfoCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.cardWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryBlue, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDarkGray)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 14, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSettingItem(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppTheme.textDarkGray, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textDarkGray)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryBlue,
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback? onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: AppTheme.textDarkGray, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textDarkGray)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
      onTap: onTap ?? () {},
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(AppLocalizations.of(context).translate('profile_settings_language')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text('繁體中文'),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(const Locale('zh', 'TW'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context, UserProfile profile) {
    final nameController = TextEditingController(text: profile.name);
    final ageController = TextEditingController(text: profile.age);
    final bloodGroupController = TextEditingController(text: profile.bloodGroup);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: bloodGroupController,
                  decoration: const InputDecoration(labelText: 'Blood Group (e.g., O+)', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedProfile = profile.copyWith(
                  name: nameController.text.trim(),
                  age: ageController.text.trim(),
                  bloodGroup: bloodGroupController.text.trim(),
                );
                await firestoreService.saveUserProfile(updatedProfile);
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showManageCaregiverDialog(BuildContext context, UserProfile profile) {
    final caregiverNameController = TextEditingController(text: profile.caregiverName);
    final caregiverLineIdController = TextEditingController(text: profile.caregiverLineUserId);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Manage Caregiver'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: caregiverNameController,
                decoration: const InputDecoration(
                  labelText: 'Caregiver Name',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Sarah',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: caregiverLineIdController,
                decoration: const InputDecoration(
                  labelText: 'Caregiver LINE User ID',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., U1234567890abcdef...',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter the LINE User ID (starts with U) of the caregiver to receive notifications.',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedProfile = profile.copyWith(
                  caregiverName: caregiverNameController.text.trim(),
                  caregiverLineUserId: caregiverLineIdController.text.trim(),
                );
                await firestoreService.saveUserProfile(updatedProfile);
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
