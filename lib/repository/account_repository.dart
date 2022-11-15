import 'package:flutter/material.dart';

class AccountRepository extends ChangeNotifier {
  bool _isAdminChecked = false;
  bool get isAdminChecked => _isAdminChecked;

  void setCheckBox(bool value) {
    _isAdminChecked = value;
    notifyListeners();
  }
}
