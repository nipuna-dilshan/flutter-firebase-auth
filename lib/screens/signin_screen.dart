import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_button.dart';
import '../components/custom_textfield.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

/// Sign In screen designed according to the NEXUS Modern Auth Flow specification.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (!success && authProvider.errorMessage != null) {
      SnackBarHelper.showError(context, authProvider.errorMessage!);
    }
    // Note: On success, AuthWrapper's stream listener automatically renders HomeScreen.
    // No manual Navigator.push/replace is needed or allowed.
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Center Logo Emblem
                  Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.secondaryPurple,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondaryPurple.withOpacity(0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: const Size(26, 26),
                          painter: _SmallNexusKeyPainter(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Welcome Back Heading
                  const Text(
                    'Welcome Back',
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
                    'Please enter your details to sign in',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColors.secondaryText,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Email Input Field
                  CustomTextField(
                    label: 'Email Address',
                    hint: 'name@example.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.mail_outline_rounded,
                    validator: Validators.validateEmail,
                  ),

                  const SizedBox(height: 18),

                  // Password Input Field
                  CustomTextField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.lock_outline_rounded,
                    onFieldSubmitted: (_) => _handleSignIn(),
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

                  const SizedBox(height: 8),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const ForgotPasswordScreen(),
                                ),
                              );
                            },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign In Button
                  CustomButton(
                    text: 'Sign In',
                    isLoading: isLoading,
                    onPressed: _handleSignIn,
                  ),

                  const SizedBox(height: 32),

                  // Sign Up Navigation Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpScreen(),
                                  ),
                                );
                              },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small white glyph painter for the Nexus icon in the Sign In screen
class _SmallNexusKeyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 4);

    // Left ring
    canvas.drawCircle(const Offset(-6, 0), 4.5, paint);

    // Right ring
    canvas.drawCircle(const Offset(6, 0), 4.5, paint);

    // Center connecting segment
    canvas.drawLine(const Offset(-1.5, 0), const Offset(1.5, 0), paint);

    // Minor notches
    canvas.drawLine(const Offset(6, 4.5), const Offset(6, 7), paint);
    canvas.drawLine(const Offset(-6, -4.5), const Offset(-6, -7), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

