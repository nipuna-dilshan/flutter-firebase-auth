import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system overlay style for a clean, edge-to-edge mobile experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  // Initialize Firebase using existing generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authController = AuthController();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthController>.value(value: authController),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authController: authController),
        ),
      ],
      child: const NexusApp(),
    ),
  );
}

class NexusApp extends StatelessWidget {
  const NexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEXUS Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryPurple,
          primary: AppColors.primaryPurple,
          secondary: AppColors.secondaryPurple,
          surface: AppColors.cardSurface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: AppColors.primaryText),
          titleTextStyle: TextStyle(
            color: AppColors.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
