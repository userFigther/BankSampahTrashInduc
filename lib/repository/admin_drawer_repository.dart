import 'package:flutter/cupertino.dart';

import '../models/admin_navigation.dart';

class AdminDrawerRepository extends ChangeNotifier {
  AdminNavigation _adminNavigation = AdminNavigation.dashboard;

  AdminNavigation get adminNavigation => _adminNavigation;

  void setAdminNavigation(AdminNavigation adminNavigation) {
    _adminNavigation = adminNavigation;

    notifyListeners();
  }
}
