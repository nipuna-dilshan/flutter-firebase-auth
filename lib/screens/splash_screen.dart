import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_colors.dart';
import 'auth_wrapper.dart';

/// Splash Screen with dark navy/purple gradient, glowing NEXUS emblem,
/// and smooth transition to AuthWrapper after 2 seconds.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_launch', false);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthWrapper(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Glowing NEXUS Logo Emblem
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF141937),
                    border: Border.all(
                      color: const Color(0xFF43497C).withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                      BoxShadow(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(56, 56),
                      painter: _NexusKeyPainter(
                        primaryColor: const Color(0xFF818CF8),
                        accentColor: const Color(0xFF38BDF8),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),

              // WELCOME subtitle
              const Text(
                'W E L C O M E',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 4.0,
                ),
              ),

              const SizedBox(height: 8),

              // NEXUS AUTH Title
              const Text(
                'NEXUS AUTH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),

              const Spacer(flex: 3),

              // Bottom Circular Progress Indicator
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF818CF8)),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter for the NEXUS stylized interlinked key glyph.
class _NexusKeyPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;

  const _NexusKeyPainter({
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [accentColor, primaryColor],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = gradient.createShader(rect);

    final center = Offset(size.width / 2, size.height / 2);

    // Draw rotated diagonal interconnected key link
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 4);

    // Left ring
    canvas.drawCircle(const Offset(-12, 0), 9, paint);

    // Right ring
    canvas.drawCircle(const Offset(12, 0), 9, paint);

    // Center crossbar connecting the two
    canvas.drawLine(const Offset(-3, 0), const Offset(3, 0), paint);

    // Small key notches
    canvas.drawLine(const Offset(12, 9), const Offset(12, 14), paint);
    canvas.drawLine(const Offset(-12, -9), const Offset(-12, -14), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _NexusKeyPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.accentColor != accentColor;
}

