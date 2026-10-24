/// Shared form validators. Each returns `null` when the value is valid,
/// otherwise the error message to show under the field.
class Validators {
  Validators._();

  /// Minimum password length. Change it here and every screen follows.
  static const int minPasswordLength = 8;

  static final RegExp _emailRe = RegExp(
    r'^[A-Za-z0-9._%+\-]+@[A-Za-z0-9\-]+(\.[A-Za-z0-9\-]+)*\.[A-Za-z]{2,}$',
  );

  // Egyptian mobile: 010 / 011 / 012 / 015 (+ optional 0 / 20 / +20 prefix).
  static final RegExp _phoneRe = RegExp(r'^(?:\+?20|0)?1[0125]\d{8}$');

  static String? email(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email is required';
    if (!_emailRe.hasMatch(v)) return 'Invalid email';
    return null;
  }

  /// Login field: accepts either an email or a phone number.
  static String? emailOrPhone(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Email or phone is required';

    if (v.contains('@')) {
      return _emailRe.hasMatch(v) ? null : 'Invalid email';
    }

    final digits = v.replaceAll(RegExp(r'[\s\-]'), '');
    return _phoneRe.hasMatch(digits) ? null : 'Invalid email or phone';
  }

  static String? fullName(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Full name is required';
    if (v.length < 3) return 'Name is too short';
    return null;
  }

  static String? phone(String? value) {
    final v = (value ?? '').replaceAll(RegExp(r'[\s\-]'), '');
    if (v.isEmpty) return 'Phone is required';
    return _phoneRe.hasMatch(v) ? null : 'Invalid phone number';
  }

  static String? required(String? value, String message) {
    return (value ?? '').trim().isEmpty ? message : null;
  }

  static String? years(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Required';
    final n = int.tryParse(v);
    if (n == null || n < 0 || n > 60) return 'Invalid';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < minPasswordLength) {
      return 'Invalid password (at least $minPasswordLength characters)';
    }
    return null;
  }

  static String? confirmPassword(String? password, String? confirm) {
    if ((confirm ?? '').isEmpty) return 'Please confirm your password';
    if (password != confirm) return 'Passwords do not match';
    return null;
  }
}
