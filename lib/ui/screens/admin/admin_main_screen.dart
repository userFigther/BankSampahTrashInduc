import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trash_induc/models/user.dart';
import 'package:trash_induc/ui/screens/admin/admin_dashboard.dart';
import 'package:trash_induc/ui/screens/admin/akun/index_account_screen.dart';
import 'package:trash_induc/ui/screens/admin/item/index_item_screen.dart';
import 'package:trash_induc/ui/screens/admin/misi/index_mission_screen.dart';
import 'package:trash_induc/ui/screens/admin/rank/index_rank_screen.dart';
import 'package:trash_induc/ui/screens/admin/reedem_reward/index_redeem_reward_screen.dart';
import 'package:trash_induc/ui/screens/admin/reward/index_reward_screen.dart';
import 'package:trash_induc/ui/screens/admin/transaksi/index_transaction_screen.dart';

import '../../../models/admin_navigation.dart';
import '../../../repository/admin_drawer_repository.dart';
import '../../../shared/color.dart';
import '../loading.dart';

class AdminMainScreen extends StatefulWidget {
  AdminMainScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  User user;

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: yellowPure,
    ));

    return buildPages();
  }

  Widget buildPages() {
    final repository = Provider.of<AdminDrawerRepository>(context);
    final currentNavigation = repository.adminNavigation;

    switch (currentNavigation) {
      case AdminNavigation.dashboard:
        return AdminDashboardScreen(
          user: widget.user,
        );
      case AdminNavigation.account:
        return AdminIndexAccountScreen();
      case AdminNavigation.trash:
        return AdminIndexItemScreen();
      case AdminNavigation.transaction:
        return AdminIndexTransactionScreen();
      case AdminNavigation.reward:
        return AdminIndexRewardScreen();
      case AdminNavigation.rank:
        return AdminIndexRankScreen();
      case AdminNavigation.mission:
        return AdminIndexMissionScreen();
      case AdminNavigation.redeem:
        return AdminIndexRedeemRewardScreen();
      case AdminNavigation.logout:
        return LogoutScreen();
    }
  }
}
