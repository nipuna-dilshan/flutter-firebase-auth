import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';

/// Home Dashboard screen matching the NEXUS design specification,
/// featuring a modern notched bottom navigation bar with elevated center action button.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Sign Out',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out of your NEXUS account?',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Sign Out',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AuthProvider>().signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    final displayName = (user?.displayName != null &&
            user!.displayName!.trim().isNotEmpty)
        ? user.displayName!
        : 'nipuna dilshan';
    final email = (user?.email != null && user!.email!.trim().isNotEmpty)
        ? user.email!
        : 'nipund001@gmail.com';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header Row: "Nexus Dashboard" and Logout Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nexus Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.primaryText,
                      size: 24,
                    ),
                    tooltip: 'Sign Out',
                    onPressed: () => _handleLogout(context),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Purple Gradient Welcome Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22.0),
                decoration: BoxDecoration(
                  gradient: AppColors.welcomeCardGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $displayName!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.35),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'PRO MEMBER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 2x2 Activity Cards
              Row(
                children: [
                  Expanded(
                    child: _ActivityCard(
                      icon: Icons.bar_chart_rounded,
                      iconColor: AppColors.analyticsIcon,
                      iconBgColor: AppColors.analyticsBg,
                      title: 'Analytics',
                      subtitle: '12 Active logs',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ActivityCard(
                      icon: Icons.cloud_done_rounded,
                      iconColor: AppColors.databaseIcon,
                      iconBgColor: AppColors.databaseBg,
                      title: 'Database',
                      subtitle: 'Connected',
                      subtitleColor: AppColors.databaseIcon,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _ActivityCard(
                      icon: Icons.shield_outlined,
                      iconColor: AppColors.securityIcon,
                      iconBgColor: AppColors.securityBg,
                      title: 'Security',
                      subtitle: 'User Authenticated',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ActivityCard(
                      icon: Icons.settings_suggest_rounded,
                      iconColor: AppColors.servicesIcon,
                      iconBgColor: AppColors.servicesBg,
                      title: 'Services',
                      subtitle: 'Ready to test',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),

      // Center Elevated Action Button matching the requested design
      floatingActionButton: Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF634CF2),
              Color(0xFF4937B8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF634CF2).withOpacity(0.42),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Quick action clicked',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: AppColors.darkNavy,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Center(
              child: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Notched bottom navigation bar matching the requested layout & color scheme
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 9.0,
        color: AppColors.cardSurface,
        elevation: 12,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        height: 66,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Group: Home & Activity
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.home_rounded,
                    label: 'Home',
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.swap_horiz_rounded,
                    label: 'Activity',
                  ),
                ],
              ),
            ),

            // Spacer for center Floating Action Button
            const SizedBox(width: 48),

            // Right Group: Analytics & Profile
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    index: 2,
                    icon: Icons.pie_chart_rounded,
                    label: 'Analytics',
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.person_rounded,
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Interactive navigation bar item with smooth active color matching NEXUS purple
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    final activeColor = const Color(0xFF634CF2);
    final inactiveColor = const Color(0xFF9CA3AF);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder activity card widget matching the reference mockup
class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final Color? subtitleColor;

  const _ActivityCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: subtitleColor ?? AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
