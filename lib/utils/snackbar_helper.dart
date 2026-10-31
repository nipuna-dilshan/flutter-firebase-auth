import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Clean, production-quality SnackBar helper matching the NEXUS design system.
class SnackBarHelper {
  SnackBarHelper._();

  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.darkNavy,
      icon: Icons.info_outline_rounded,
    );
  }

  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 4),
        elevation: 4,
      ),
    );
  }
}

