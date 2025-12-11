import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = User(
      id: '1',
      name: 'John Delacruz',
      email: email,
      department: 'Human Resources',
      role: 'HR Specialist',
    );
    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
