import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _userId;

  String? get userId => _userId;

  bool get isLoggedIn => _userId != null;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

  void clearUserId() {
    _userId = null;
    notifyListeners();
  }
}