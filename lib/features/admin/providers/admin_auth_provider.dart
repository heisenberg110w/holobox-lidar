import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Auth provider for client app - allows any authenticated user
class ClientAuthProvider extends ChangeNotifier {
  final bool demoMode;
  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  ClientAuthProvider({
    required this.demoMode,
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = demoMode ? null : (auth ?? FirebaseAuth.instance),
        _firestore = demoMode ? null : (firestore ?? FirebaseFirestore.instance);

  StreamSubscription<User?>? _sub;

  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  User? _user;
  User? get user => _user;

  String? _demoUid;
  String? get uid => demoMode ? _demoUid : _user?.uid;
  String? get userEmail => demoMode ? 'demo@holobox.com' : _user?.email;

  bool get isSignedIn => demoMode ? (_demoUid != null) : (_user != null);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> init() async {
    if (demoMode) {
      _isInitializing = false;
      _demoUid = null;
      notifyListeners();
      return;
    }

    _sub?.cancel();
    _sub = _auth!.authStateChanges().listen((user) async {
      _user = user;
      _errorMessage = null;
      _isInitializing = false;

      if (user != null) {
        // Store/update user info in Firestore
        try {
          await _firestore!.collection('clients').doc(user.uid).set({
            'email': user.email,
            'lastLogin': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        } catch (_) {
          // Non-critical, ignore
        }
      }

      notifyListeners();
    });
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _errorMessage = null;
    notifyListeners();

    try {
      if (demoMode) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (email.trim().isEmpty || password.isEmpty) {
          _errorMessage = 'Enter email and password.';
          notifyListeners();
          return;
        }
        _demoUid = 'demo-client';
        notifyListeners();
        return;
      }
      await _auth!.signInWithEmailAndPassword(email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? 'Login failed.';
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Login failed. ($e)';
      notifyListeners();
    }
  }

  Future<void> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    _errorMessage = null;
    notifyListeners();

    try {
      if (demoMode) {
        await Future.delayed(const Duration(milliseconds: 300));
        if (email.trim().isEmpty || password.isEmpty) {
          _errorMessage = 'Enter email and password.';
          notifyListeners();
          return;
        }
        _demoUid = 'demo-client';
        notifyListeners();
        return;
      }

      final credential = await _auth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update display name if provided
      if (displayName != null && displayName.isNotEmpty && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
      }

      // Create client profile in Firestore
      if (credential.user != null) {
        await _firestore!.collection('clients').doc(credential.user!.uid).set({
          'email': email.trim(),
          'displayName': displayName ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorMessage = 'Password is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _errorMessage = 'An account already exists with this email.';
      } else if (e.code == 'invalid-email') {
        _errorMessage = 'Invalid email address.';
      } else {
        _errorMessage = e.message ?? 'Sign up failed.';
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Sign up failed. ($e)';
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _errorMessage = null;
    if (demoMode) {
      _demoUid = null;
      notifyListeners();
      return;
    }
    await _auth!.signOut();
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

// Keep old name as alias for compatibility during transition
typedef AdminAuthProvider = ClientAuthProvider;

