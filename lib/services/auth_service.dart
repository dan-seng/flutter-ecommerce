import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.isAnonymous = false,
  });

  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final bool isAnonymous;

  factory AppUser.fromFirebase(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? 'user@example.com',
      displayName: user.displayName ?? user.email?.split('@').first ?? 'Alex Johnson',
      photoUrl: user.photoURL,
      isAnonymous: user.isAnonymous,
    );
  }

  static const mock = AppUser(
    uid: 'mock_user_123',
    email: 'alex.johnson@example.com',
    displayName: 'Alex Johnson',
  );
}

class AuthService extends ChangeNotifier {
  AuthService({FirebaseAuth? firebaseAuth, AppUser? initialUser})
      : _currentUser = initialUser,
        _auth = firebaseAuth ?? (_isFirebaseInitialized() ? FirebaseAuth.instance : null) {
    _init();
  }

  final FirebaseAuth? _auth;
  AppUser? _currentUser;
  bool _isLoading = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;

  static bool _isFirebaseInitialized() {
    try {
      return FirebaseAuth.instance.app.name.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _init() {
    if (_auth != null) {
      _auth.userChanges().listen((User? user) {
        if (user != null) {
          _currentUser = AppUser.fromFirebase(user);
        } else {
          _currentUser = null;
        }
        notifyListeners();
      });
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      if (_auth != null) {
        final credential = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        if (credential.user != null) {
          _currentUser = AppUser.fromFirebase(credential.user!);
        }
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        _currentUser = AppUser(
          uid: 'user_${email.hashCode}',
          email: email,
          displayName: email.split('@').first,
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      if (_auth != null) {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        if (credential.user != null) {
          await credential.user!.updateDisplayName(name.trim());
          _currentUser = AppUser.fromFirebase(credential.user!);
        }
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        _currentUser = AppUser(
          uid: 'user_${email.hashCode}',
          email: email,
          displayName: name.trim(),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      if (_auth != null) {
        try {
          await GoogleSignIn.instance.initialize(
            serverClientId:
                '587970089280-t86mik3e419u8t3k4i3ulrqe54fb99n8.apps.googleusercontent.com',
          );
        } catch (_) {}
        final GoogleSignInAccount googleAccount =
            await GoogleSignIn.instance.authenticate();
        final googleAuth = googleAccount.authentication;
        final OAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        final userCredential = await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          _currentUser = AppUser.fromFirebase(userCredential.user!);
        }
      } else {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        _currentUser = const AppUser(
          uid: 'google_user_999',
          email: 'alex.google@example.com',
          displayName: 'Alex (Google)',
        );
      }
    } catch (e) {
      debugPrint('Google Sign-In Error Details: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    final cleanEmail = email.trim();
    debugPrint('Password reset requested for: $cleanEmail (Firebase Auth active: ${_auth != null})');
    if (_auth != null) {
      await _auth.sendPasswordResetEmail(email: cleanEmail);
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 600));
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      if (_auth != null) {
        try {
          await _auth.signOut();
        } catch (_) {}
        try {
          await GoogleSignIn.instance.signOut();
        } catch (_) {}
      }
      _currentUser = null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
