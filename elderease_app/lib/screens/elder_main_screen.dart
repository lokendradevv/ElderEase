import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'elder_home_screen.dart';

class ElderMainScreen extends StatefulWidget {
  const ElderMainScreen({super.key});

  @override
  State<ElderMainScreen> createState() => _ElderMainScreenState();
}

class _ElderMainScreenState extends State<ElderMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ElderHomeScreen(),
    const Center(child: Text('History Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue))),
    const Center(child: Text('Alerts & Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue))),
    const Center(child: Text('Patient Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppTheme.primaryBlue))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundOffWhite,
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Premium Floating Bar with Notch
              PhysicalShape(
                color: Colors.white,
                elevation: 12,
                shadowColor: Colors.black.withValues(alpha: 0.15),
                clipper: NotchedBarClipper(),
                child: SizedBox(
                  height: 75,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavItem(Icons.home_outlined, Icons.home_rounded, 'Home', 0),
                      _buildNavItem(Icons.history_outlined, Icons.history_rounded, 'History', 1),
                      const SizedBox(width: 84), // Space for center center elevated button
                      _buildNavItem(Icons.notifications_none_outlined, Icons.notifications_rounded, 'Alerts', 2, hasBadge: true),
                      _buildNavItem(Icons.person_outline, Icons.person_rounded, 'Profile', 3),
                    ],
                  ),
                ),
              ),
              // Floating Action Button
              Positioned(
                top: -24,
                child: GestureDetector(
                  onTap: () {
                    // Action to add medication
                  },
                  child: Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryBlueLight, AppTheme.primaryBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.add_rounded, size: 36, color: Colors.white),
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

  Widget _buildNavItem(IconData unselectedIcon, IconData selectedIcon, String label, int index, {bool hasBadge = false}) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppTheme.primaryBlue : AppTheme.textMuted.withValues(alpha: 0.5);

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
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
                if (hasBadge)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.errorRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: color,
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}

class NotchedBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final host = Rect.fromLTWH(0, 0, size.width, size.height);
    final guest = Rect.fromLTWH((size.width - 64) / 2, -24, 64, 64);
    final notchMargin = 6.0;
    
    final guestWithMargin = Rect.fromLTRB(
      guest.left - notchMargin, 
      guest.top - notchMargin, 
      guest.right + notchMargin, 
      guest.bottom + notchMargin
    );
    
    final notchedPath = const CircularNotchedRectangle().getOuterPath(host, guestWithMargin);
    final roundedPath = Path()..addRRect(RRect.fromRectAndRadius(host, const Radius.circular(35)));
    
    return Path.combine(PathOperation.intersect, notchedPath, roundedPath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
