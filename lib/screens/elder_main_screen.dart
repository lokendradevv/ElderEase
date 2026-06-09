import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'elder_home_screen.dart';
import 'elder_med_screen.dart';
import 'elder_profile_screen.dart';
import 'elder_history_screen.dart';
import 'camera_screen.dart';
import '../l10n/app_localizations.dart';
import '../models/medication.dart';

class ElderMainScreen extends StatefulWidget {
  const ElderMainScreen({super.key});

  @override
  State<ElderMainScreen> createState() => _ElderMainScreenState();
}

class _ElderMainScreenState extends State<ElderMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ElderHomeScreen(),
    const ElderMedScreen(),
    const ElderHistoryScreen(),
    const ElderProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      extendBody: true, // Let body extend under the floating nav bar
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              // Pill shaped navigation bar
              Container(
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(37.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(Icons.home_outlined, Icons.home_rounded, AppLocalizations.of(context).translate('nav_home'), 0),
                    _buildNavItem(Icons.vaccines_outlined, Icons.vaccines_rounded, AppLocalizations.of(context).translate('nav_med'), 1),
                    const SizedBox(width: 72), // Space for the center SCAN button
                    _buildNavItem(Icons.history_outlined, Icons.history_rounded, AppLocalizations.of(context).translate('nav_history'), 2),
                    _buildNavItem(Icons.person_outline, Icons.person_rounded, AppLocalizations.of(context).translate('nav_profile'), 3),
                  ],
                ),
              ),
              // Floating Center SCAN Button
              Positioned(
                bottom: 30, // Overlaps the pill container to sit firmly above and slightly overlaid
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(
                          medication: Medication(id: 'scan', name: 'Scan Medicine', dosage: '', time: ''),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF60A5FA), AppTheme.primaryBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.qr_code_scanner_rounded, size: 38, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData unselectedIcon, IconData selectedIcon, String label, int index) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppTheme.primaryBlue : AppTheme.textMuted.withValues(alpha: 0.6);

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isSelected ? selectedIcon : unselectedIcon,
                key: ValueKey(isSelected),
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
