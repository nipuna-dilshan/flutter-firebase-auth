import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';

/// Password recovery screen matching the NEXUS design system.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendPasswordReset(
      email: _emailController.text,
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        _emailSent = true;
      });
      SnackBarHelper.showSuccess(
        context,
        'Password reset link sent! Please check your email inbox.',
      );
    } else if (authProvider.errorMessage != null) {
      SnackBarHelper.showError(context, authProvider.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryText,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon badge
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryPurple.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lock_reset_rounded,
                          color: AppColors.primaryPurple,
                          size: 32,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Heading
                  const Text(
                    'Forgot Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryText,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    'Enter your registered email address to receive a secure password reset link.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColors.secondaryText,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Email Field
                  CustomTextField(
                    label: 'Email Address',
                    hint: 'name@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.mail_outline_rounded,
                    onFieldSubmitted: (_) => _handleResetPassword(),
                    validator: Validators.validateEmail,
                  ),

                  const SizedBox(height: 28),

                  // Send Reset Link Button
                  CustomButton(
                    text: _emailSent ? 'Resend Reset Link' : 'Send Reset Link',
                    isLoading: isLoading,
                    onPressed: _handleResetPassword,
                  ),

                  const SizedBox(height: 24),

                  // Back to Sign In Link
                  Center(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primaryPurple,
                      ),
                      onPressed: isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded, size: 16),
                      label: const Text(
                        'Back to Sign In',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

