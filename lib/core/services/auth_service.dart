import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../database/user_repository.dart';
import '../models/app_user.dart';

class AuthResult {
  final User firebaseUser;
  final AppUser? appUser;
  final bool needsRoleSelection;

  const AuthResult({
    required this.firebaseUser,
    required this.appUser,
    this.needsRoleSelection = false,
  });
}

class AuthService {
  AuthService({FirebaseAuth? auth, UserRepository? userRepository})
    : _auth = auth ?? FirebaseAuth.instance,
      _userRepo = userRepository ?? UserRepository();

  final FirebaseAuth _auth;
  final UserRepository _userRepo;

  static bool _isInitialized = false;

  static Future<void> _ensureInitialized() async {
    if (_isInitialized) return;
    await GoogleSignIn.instance.initialize();
    _isInitialized = true;
  }

  Future<AuthResult> signInWithEmailOrPhone({
    required String identifier,
    required String password,
  }) async {
    final trimmed = identifier.trim();
    String emailToUse = trimmed;

    if (!trimmed.contains('@')) {
      final matchedUser = await _userRepo.findUserByPhone(trimmed);
      if (matchedUser == null || matchedUser.email.isEmpty) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'لا يوجد حساب مرتبط برقم الهاتف هذا.',
        );
      }
      emailToUse = matchedUser.email;
    }

    final credential = await _auth.signInWithEmailAndPassword(
      email: emailToUse,
      password: password,
    );

    final user = credential.user!;
    await _userRepo.updateLastLogin(user.uid);
    final appUser = await _userRepo.getUserById(user.uid);

    return AuthResult(
      firebaseUser: user,
      appUser: appUser,
      needsRoleSelection: appUser == null || !appUser.isProfileComplete,
    );
  }

  Future<AuthResult> signUpClient({
    required String fullName,
    required String phone,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user!;
    await user.updateDisplayName(fullName.trim());

    await _userRepo.createUserDoc(
      firebaseUser: user,
      fullName: fullName,
      phone: phone,
      role: UserRole.client,
      isProfileComplete: true,
    );

    final appUser = await _userRepo.getUserById(user.uid);
    return AuthResult(firebaseUser: user, appUser: appUser);
  }

  Future<AuthResult> signUpTechnician({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required String area,
    String specialty = 'General',
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user!;
    await user.updateDisplayName(fullName.trim());

    await _userRepo.createUserDoc(
      firebaseUser: user,
      fullName: fullName,
      phone: phone,
      role: UserRole.technician,
      isProfileComplete: true,
      area: area,
      specialty: specialty,
    );

    final appUser = await _userRepo.getUserById(user.uid);
    return AuthResult(firebaseUser: user, appUser: appUser);
  }

  Future<AuthResult?> signInWithGoogle() async {
    try {
      await _ensureInitialized();

      final GoogleSignInAccount account = await GoogleSignIn.instance
          .authenticate();
      final GoogleSignInAuthentication googleAuth = account.authentication;

      if (googleAuth.idToken == null) {
        throw FirebaseAuthException(
          code: 'missing-id-token',
          message:
              'لم يتم استلام idToken من Google. تأكد من ضبط SHA-1 و Web Client ID في Firebase.',
        );
      }

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user!;

      AppUser? appUser = await _userRepo.getUserById(user.uid);
      if (appUser == null) {
        await _userRepo.createUserDoc(
          firebaseUser: user,
          fullName: user.displayName ?? 'Fixly User',
          phone: user.phoneNumber,
          role: UserRole.client,
          isProfileComplete: true,
        );
        appUser = await _userRepo.getUserById(user.uid);
      } else {
        await _userRepo.updateLastLogin(user.uid);
      }

      return AuthResult(
        firebaseUser: user,
        appUser: appUser,
        needsRoleSelection: appUser == null || !appUser.isProfileComplete,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      throw Exception(
        'فشل تسجيل الدخول بجوجل (${e.code}): ${e.description ?? ''}',
      );
    }
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    await _ensureInitialized();
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}
