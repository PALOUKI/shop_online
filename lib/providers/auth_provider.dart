import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  UserModel? _currentUser;
  bool _isLoading = false;

  AuthProvider(this._authService) {
    _loadCurrentUser();
  }

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  void _loadCurrentUser() {
    _currentUser = _authService.getCurrentUser();
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (success) {
        _loadCurrentUser();
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _authService.signIn(
        email: email,
        password: password,
      );

      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authService.signOut();
    _currentUser = null;

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? address,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = _currentUser!.copyWith(
        fullName: fullName,
        phoneNumber: phoneNumber,
        address: address,
      );

      final success = await _authService.updateUserProfile(updatedUser);
      if (success) {
        _currentUser = updatedUser;
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
