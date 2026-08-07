import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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
  AuthService({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? (_isFirebaseInitialized() ? FirebaseAuth.instance : null) {
    _init();
  }

  final FirebaseAuth? _auth;
  AppUser? _currentUser = AppUser.mock;
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
        // Fallback simulation for local dev
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

  Future<void> sendPasswordReset(String email) async {
    if (_auth != null) {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      if (_auth != null) {
        await _auth.signOut();
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
