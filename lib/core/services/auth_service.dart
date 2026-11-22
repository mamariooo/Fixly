import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '998174646288-0sc6rvmk1b3qu36ln995acifec1fq7n4.apps.googleusercontent.com',
    );
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
      debugPrint('GOOGLE 1: Initializing...');

      await _ensureInitialized();

      debugPrint('GOOGLE 2: Opening account picker...');

      final account = await GoogleSignIn.instance.authenticate();

      debugPrint('GOOGLE 3: Account selected: ${account.email}');

      final googleAuth = account.authentication;

      debugPrint('GOOGLE 4: ID Token received: ${googleAuth.idToken != null}');

      if (googleAuth.idToken == null) {
        throw Exception('Google ID Token is null');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      debugPrint('GOOGLE 5: Signing in with Firebase...');

      final userCred = await _auth.signInWithCredential(credential);

      final user = userCred.user!;

      debugPrint('GOOGLE 6: Firebase login successful: ${user.uid}');

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

      debugPrint('GOOGLE 7: Login process completed');

      return AuthResult(
        firebaseUser: user,
        appUser: appUser,
        needsRoleSelection: appUser == null || !appUser.isProfileComplete,
      );
    } catch (e, stackTrace) {
      debugPrint('GOOGLE LOGIN ERROR: $e');
      debugPrint('GOOGLE STACK TRACE: $stackTrace');
      rethrow;
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
