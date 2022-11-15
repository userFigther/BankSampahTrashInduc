import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/mission.dart';

class TransactionRepository extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  Future<List<Mission>>? _futureListMissions;

  List<CartItem> get cartItems => _cartItems;

  Future<List<Mission>>? get futureListMission => _futureListMissions;

  String? _selectedUserId;
  List<Mission> _missions = [];

  String? get userId => _selectedUserId;
  List<Mission> get missions => _missions;

  bool _isSampahChecked = false;
  bool get isSampahChecked => _isSampahChecked;

  void setFutureListMission(Future<List<Mission>> future) {
    _futureListMissions = future;
  }

  void addItem(CartItem item) {
    var existingItem =
        _cartItems.indexWhere((ci) => ci.item.id == item.item.id);

    if (existingItem > -1) {
      _cartItems[existingItem].qty += item.qty;
    } else {
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _cartItems.removeAt(_cartItems.indexOf(item));
    notifyListeners();
  }

  void updateItem(CartItem item) {
    var find = _cartItems.where((CartItem ci) => ci.item.id == item.item.id);
    if (find.isNotEmpty) {
      _cartItems[_cartItems.indexOf(find.first)] = item;
    }

    notifyListeners();
  }

  double getTotalXp() {
    double totalExp = 0;
    _cartItems.forEach((CartItem item) {
      totalExp += item.qty * item.item.exp_point!;
    });
    _missions.forEach((element) {
      totalExp += element.exp!;
    });
    return totalExp + (_isSampahChecked ? 5 : 0);
  }

  double getTotalBalance() {
    double totalBalance = 0;
    _cartItems.forEach((CartItem item) {
      totalBalance += item.qty * item.item.balance_point!;
      totalBalance += item.qty * item.price;
    });
    _missions.forEach((element) {
      totalBalance += element.balance!;
    });
    return totalBalance + (_isSampahChecked ? 5 : 0);
  }

  void setUserId(String userId) {
    _selectedUserId = userId;
    notifyListeners();
  }

  void setMissions(List<Mission> missions) {
    _missions = missions;
    notifyListeners();
  }

  void setCheckBox(bool value) {
    _isSampahChecked = value;
    notifyListeners();
  }

  void removeAllItem() {
    _selectedUserId = '';
    _cartItems = [];
    _missions = [];
    _isSampahChecked = false;
    notifyListeners();
  }
}
