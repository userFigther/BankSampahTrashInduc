import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../models/admin_navigation.dart';
import '../../repository/admin_drawer_repository.dart';
import '../../shared/color.dart';
import '../../shared/font.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({Key? key,
  }) : super(key: key);



  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: darkGreen,
      child: ListView(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Admin",
                  style: boldRobotoFont.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  "Trash Induc ",
                  style: regularRobotoFont.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  "(v 1.0)",
                  style: regularRobotoFont.copyWith(
                    fontSize: 8.sp,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: lightGreen,
            ),
          ),
          buildTile(
            context,
            item: AdminNavigation.dashboard,
            title: "Dashboard",
            image: Image.asset("assets/images/dashboardIcon.png"),
          ),
          buildTile(
            context,
            item: AdminNavigation.account,
            color: veryLightGray,
            title: "Akun",
            image: Image.asset("assets/images/akunIcon.png"),
          ),
          buildTile(
            context,
            item: AdminNavigation.trash,
            title: "Sampah",
            image: Image.asset("assets/images/sampahIcon.png"),
          ),
          buildTile(
            context,
            item: AdminNavigation.transaction,
            color: veryLightGray,
            title: "Transaksi",
            image: Image.asset("assets/images/transaksiIcon.png"),
          ),
          buildTile(
            context,
            item: AdminNavigation.reward,
            title: "Reward",
            image: Image.asset("assets/images/rewardIcon.png"),
          ),
          buildTile(
            context,
            item: AdminNavigation.redeem,
            color: veryLightGray,
            title: "Reedem Reward",
            image: Image.asset("assets/images/rewardIcon.png"),
          ),
          buildTile(
            context,
            item: AdminNavigation.rank,
            title: "Rank",
            image: Image.asset("assets/images/rankIcon.png"),
          ),
          buildTile(
            context,
            item: AdminNavigation.mission,
            title: "Misi",
            color: veryLightGray,
            image: Image.asset(
              "assets/images/missionIcon.png",
              height: 30,
            ),
          ),
          buildTile(context,
              item: AdminNavigation.logout,
              title: "Keluar",
              image: Image.asset(
                "assets/images/exit.png",
                color: redDanger,
              ))
        ],
      ),
    );
  }

  Widget buildTile(
    BuildContext context, {
    required AdminNavigation item,
    required String title,
    required Image image,
    Color color = whitePure,
  }) {
    final repository = Provider.of<AdminDrawerRepository>(context);
    final currentSelected = repository.adminNavigation;
    final isSelected = item == currentSelected;

    return Ink(
      color: color,
      child: ListTile(
        onTap: () => selectTile(context, item),
        selected: isSelected,
        selectedTileColor: lightYellow,
        leading: image,
        title: Text(
          title,
          style: mediumRobotoFont.copyWith(
            fontSize: 12.sp,
            color: darkGray,
          ),
        ),
      ),
    );
  }

  void selectTile(BuildContext context, AdminNavigation item) {
    final repository = Provider.of<AdminDrawerRepository>(
      context,
      listen: false,
    );

    repository.setAdminNavigation(item);
  }
}
