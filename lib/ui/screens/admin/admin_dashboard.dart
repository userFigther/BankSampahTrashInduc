import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trash_induc/models/user.dart';
import 'package:trash_induc/ui/widgets/dashboard_grid.dart';

import '../../../shared/color.dart';
import '../../../shared/font.dart';
import '../../widgets/admin_drawer.dart';

class AdminDashboardScreen extends StatefulWidget {
  AdminDashboardScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  User user;

  @override
  AdminDashboardScreenState createState() => AdminDashboardScreenState();
}

class AdminDashboardScreenState extends State<AdminDashboardScreen> {
  var height = 0.4.sh;
  var width = 0.25.sw;

  Future<int> fetchData(String data) async {
    var response = await FirebaseFirestore.instance.collection(data).get();
    return response.docs.length;
  }

  Future<int> fetchPendingRewards() async {
    var response = await FirebaseFirestore.instance
        .collection('user_redeemed_rewards')
        .where('status', isEqualTo: 'pending')
        .get();
    return response.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF527D46),
            Color(0xFF7EB044),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: const AdminDrawer(),
        appBar: AppBar(
          backgroundColor: darkGreen,
          leading: Builder(
            builder: (context) {
              return IconButton(
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                icon: Image.asset(
                  "assets/images/buttonSidebar.png",
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
          title: Text(
            "Dashboard",
            style: boldRobotoFont.copyWith(
              fontSize: 14.sp,
            ),
          ),
          titleSpacing: 0,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 15.w,
                top: 20.h,
              ),
              child: Text(
                'Halo ${widget.user.name}',
                style: mediumRobotoFont.copyWith(
                  fontSize: 12.sp,
                ),
              ),
            ),
            GridView.count(
              physics: const ScrollPhysics(),
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: 0.7 / 0.38,
              padding: EdgeInsets.symmetric(
                horizontal: 50.w,
                vertical: 50.h,
              ),
              children: [
                FutureBuilder<int>(
                    future: fetchData('users'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          color: yellowPure,
                        );
                      }
                      return DashboardGrid(
                        data: snapshot.data!,
                        icon: Icons.person,
                        label: 'Pengguna',
                      );
                    }),
                FutureBuilder<int>(
                    future: fetchData('transactions'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: yellowPure,
                        );
                      }
                      return DashboardGrid(
                        data: snapshot.data!,
                        icon: Icons.handshake,
                        label: 'Transaksi',
                      );
                    }),
                FutureBuilder<int>(
                    future: fetchData('items'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          color: yellowPure,
                        );
                      }
                      return DashboardGrid(
                        data: snapshot.data!,
                        icon: Icons.delete,
                        label: 'Jenis Sampah',
                      );
                    }),
                FutureBuilder<int>(
                    future: fetchData('missions'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          color: yellowPure,
                        );
                      }
                      return DashboardGrid(
                        data: snapshot.data!,
                        icon: Icons.task,
                        label: 'Misi',
                      );
                    }),
                FutureBuilder<int>(
                    future: fetchData('rewards'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          color: yellowPure,
                        );
                      }
                      return DashboardGrid(
                        data: snapshot.data!,
                        icon: Icons.task,
                        label: 'Reward',
                      );
                    }),
                FutureBuilder<int>(
                    future: fetchPendingRewards(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          color: yellowPure,
                        );
                      }
                      return DashboardGrid(
                        data: snapshot.data!,
                        icon: Icons.task,
                        label: 'Persetujuan Reward',
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
