import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';

/// Sign Up screen matching the NEXUS design specification.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signUp(
      email: _emailController.text,
      password: _passwordController.text,
      fullName: _fullNameController.text,
    );

    if (!mounted) return;

    if (!success && authProvider.errorMessage != null) {
      SnackBarHelper.showError(context, authProvider.errorMessage!);
    } else {
      // Pop pushed routes back to root (AuthWrapper)
      // AuthWrapper reactively switches to HomeScreen driven by authStateChanges.
      Navigator.of(context).popUntil((route) => route.isFirst);
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
                  // Heading
                  const Text(
                    'Create Account',
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
                    'Fill in your details below to get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColors.secondaryText,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Full Name Field
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'John Doe',
                    controller: _fullNameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.person_outline_rounded,
                    validator: Validators.validateFullName,
                  ),

                  const SizedBox(height: 16),

                  // Email Field
                  CustomTextField(
                    label: 'Email Address',
                    hint: 'name@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.mail_outline_rounded,
                    validator: Validators.validateEmail,
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  CustomTextField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.secondaryText,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: Validators.validatePassword,
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password Field
                  CustomTextField(
                    label: 'Confirm Password',
                    hint: '••••••••',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.lock_outline_rounded,
                    onFieldSubmitted: (_) => _handleSignUp(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.secondaryText,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    validator: (val) => Validators.validateConfirmPassword(
                      val,
                      _passwordController.text,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Sign Up Button
                  CustomButton(
                    text: 'Sign Up',
                    isLoading: isLoading,
                    onPressed: _handleSignUp,
                  ),

                  const SizedBox(height: 24),

                  // Already have an account link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                    ],
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

