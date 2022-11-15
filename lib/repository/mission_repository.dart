import 'package:flutter/cupertino.dart';

class MissionRepository extends ChangeNotifier {
  bool _isSembunyikanChecked = false;
  bool get isSembunyikanChecked => _isSembunyikanChecked;

  bool _isAktifkanChecked = false;
  bool get isAktifkanChecked => _isAktifkanChecked;

  void setCheckBoxSembunyikan(bool value) {
    _isSembunyikanChecked = value;
    notifyListeners();
  }

  void setCheckBoxAktifkan(bool value) {
    _isAktifkanChecked = value;
    notifyListeners();
  }

  void clearAll() {
    _isAktifkanChecked = false;
    _isSembunyikanChecked = false;
    notifyListeners();
  }
}
