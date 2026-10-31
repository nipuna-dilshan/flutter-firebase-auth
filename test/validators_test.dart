import 'package:flutter_test/flutter_test.dart';
import 'package:email_signin_flutter/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('validateEmail validates correctly', () {
      expect(Validators.validateEmail(''), 'Email address is required');
      expect(Validators.validateEmail(null), 'Email address is required');
      expect(Validators.validateEmail('invalid-email'), 'Please enter a valid email address');
      expect(Validators.validateEmail('user@'), 'Please enter a valid email address');
      expect(Validators.validateEmail('user@domain.com'), isNull);
      expect(Validators.validateEmail('  user.test@domain.co.uk  '), isNull);
    });

    test('validatePassword validates length and presence', () {
      expect(Validators.validatePassword(''), 'Password is required');
      expect(Validators.validatePassword(null), 'Password is required');
      expect(Validators.validatePassword('12345'), 'Password must be at least 6 characters');
      expect(Validators.validatePassword('123456'), isNull);
      expect(Validators.validatePassword('securePassword!'), isNull);
    });

    test('validateConfirmPassword ensures password match', () {
      expect(Validators.validateConfirmPassword('', '123456'), 'Please confirm your password');
      expect(Validators.validateConfirmPassword(null, '123456'), 'Please confirm your password');
      expect(Validators.validateConfirmPassword('123457', '123456'), 'Passwords do not match');
      expect(Validators.validateConfirmPassword('123456', '123456'), isNull);
    });

    test('validateFullName ensures non-empty and minimum length', () {
      expect(Validators.validateFullName(''), 'Full name is required');
      expect(Validators.validateFullName(null), 'Full name is required');
      expect(Validators.validateFullName('a'), 'Please enter your full name');
      expect(Validators.validateFullName('John Doe'), isNull);
    });
  });
}

