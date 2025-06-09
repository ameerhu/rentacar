import 'package:flutter/material.dart';
import 'package:frontend/_services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool? _isAuthenticated;
  bool? get isAuthenticated => _isAuthenticated;

  AuthProvider() {
    _authService.isTokenValid().then((value) => {
      setAuthentication(value),
    });
  }

  setAuthentication(bool auth) {
    _isAuthenticated = auth;
    notifyListeners();
  }
}