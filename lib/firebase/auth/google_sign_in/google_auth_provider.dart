import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import 'google_auth_service.dart';

class GoogleAuthProvider extends ChangeNotifier {
  final GoogleAuthService _service = GoogleAuthService();

  UserModel? _user;
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  // Check if user already logged in when app starts
  void checkCurrentUser() {
    _user = _service.getCurrentUser();
    notifyListeners();
  }

  // SIGN IN WITH GOOGLE
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    _user = await _service.signInWithGoogle();

    _isLoading = false;

    if (_user == null) {
      _errorMessage = 'Google Sign In failed. Please try again.';
    }

    notifyListeners();
    return _user != null;
  }

  // SIGN OUT
  Future<void> signOut() async {
    await _service.signOut();
    _user = null;
    notifyListeners();
  }
}