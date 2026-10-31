import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';
import '../controllers/auth_controller.dart';

/// Application state provider for authentication, managing loading states,
/// user profile state, and delegating Firebase operations to AuthController.
class AuthProvider extends ChangeNotifier {
  final AuthController _authController;

  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({AuthController? authController})
      : _authController = authController ?? AuthController();

  /// Whether an authentication async action is currently in progress.
  bool get isLoading => _isLoading;

  /// The most recent error message, if any.
  String? get errorMessage => _errorMessage;

  /// The currently signed-in Firebase user.
  User? get currentUser => _authController.currentUser;

  /// Stream of auth changes for reactive UI updates.
  Stream<User?> get authStateStream => _authController.authStateChanges;

  /// Clears current error message.
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Sets loading state and notifies listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Signs in with email and password.
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authController.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Registers a new user with full name, email, and password.
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authController.signUpWithEmailAndPassword(
        email: email,
        password: password,
        fullName: fullName,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Sends a password reset email.
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> sendPasswordReset({required String email}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authController.sendPasswordResetEmail(email: email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Signs out the currently authenticated user.
  Future<void> signOut() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authController.signOut();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }
}
