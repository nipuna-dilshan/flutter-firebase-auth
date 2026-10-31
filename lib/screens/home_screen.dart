import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';

/// Home Dashboard screen matching the NEXUS design specification.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      // Calling signOut triggers authStateChanges which automatically
      // prompts AuthWrapper to render SignInScreen.
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
        : 'John Doe';
    final email = (user?.email != null && user!.email!.trim().isNotEmpty)
        ? user.email!
        : 'name@example.com';

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

              const SizedBox(height: 24),
            ],
          ),
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

