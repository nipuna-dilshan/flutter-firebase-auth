import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Reusable full-width action button adhering to the NEXUS design system.
/// Supports gradient styling, loading indicator, and tap feedback.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.height = 52.0,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPress = onPressed != null && !isLoading;

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: canPress ? AppColors.buttonGradient : null,
        color: canPress ? null : AppColors.primaryPurple.withValues(alpha: 0.6),
        boxShadow: canPress
            ? [
                BoxShadow(
                  color: AppColors.primaryPurple.withValues(alpha: 0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: canPress ? onPressed : null,
          splashColor: Colors.white24,
          highlightColor: Colors.white10,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

