import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import 'email_auth_service.dart';

class EmailAuthProvider extends ChangeNotifier {
  // Service instance — provider talks to service
  final EmailAuthService _service = EmailAuthService();

  // State variables
  UserModel? _user;        // currently logged in user
  bool _isLoading = false; // to show loading spinner
  String _errorMessage = ''; // to show error to user

  // Getters — screen reads these
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  // Called when app starts — check if user already logged in
  void checkCurrentUser() {
    _user = _service.getCurrentUser();
    notifyListeners(); // tell UI to rebuild
  }

  // SIGN UP
  Future<bool> signUp(String email, String password, String name) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    _user = await _service.signUp(email, password, name);

    _isLoading = false;

    if (_user == null) {
      _errorMessage = 'Sign up failed. Please try again.';
    }

    notifyListeners();
    return _user != null; // return true if success
  }

  // SIGN IN
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    _user = await _service.signIn(email, password);

    _isLoading = false;

    if (_user == null) {
      _errorMessage = 'Sign in failed. Check email or password.';
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