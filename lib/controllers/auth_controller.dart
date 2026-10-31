import 'package:firebase_auth/firebase_auth.dart';

/// Controller encapsulating all direct Firebase Authentication SDK operations.
/// Completely decoupled from UI logic.
class AuthController {
  final FirebaseAuth _firebaseAuth;

  AuthController({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Stream of authentication state changes.
  /// Automatically persists sessions across app restarts.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Gets the currently authenticated Firebase user, if any.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Signs in a user with email and password.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw getReadableErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred during sign in. Please try again.';
    }
  }

  /// Registers a new user with email, password, and sets their display name.
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update the user's display name
      final user = credential.user;
      if (user != null) {
        await user.updateDisplayName(fullName.trim());
        await user.reload();
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw getReadableErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred during registration. Please try again.';
    }
  }

  /// Sends a password reset email to the specified address.
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw getReadableErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred sending reset link. Please try again.';
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw getReadableErrorMessage(e);
    } catch (e) {
      throw 'An error occurred while signing out. Please try again.';
    }
  }

  /// Maps Firebase error codes to clean, human-readable user messages.
  String getReadableErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please verify and try again.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials.';
      case 'email-already-in-use':
        return 'An account already exists for this email address.';
      case 'invalid-email':
        return 'The provided email address is invalid.';
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'operation-not-allowed':
        return 'Email/Password sign-in is not enabled in Firebase Console.';
      case 'network-request-failed':
        return 'Network connection failed. Please check your internet connection.';
      default:
        return e.message ?? 'An authentication error occurred. (${e.code})';
    }
  }
}

