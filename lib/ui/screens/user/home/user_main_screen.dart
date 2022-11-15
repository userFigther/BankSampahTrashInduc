import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trash_induc/models/user.dart';

import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../profile/user_profile_screen.dart';
import 'user_home_screen.dart';
import '../transaction/user_transaction_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  User user;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: lightGreen,
    ));

    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND: LINEAR BACKGROUND
          Container(
            width: 1.sw,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF527D46),
                  Color(0xFF7EB044),
                ],
              ),
            ),
          ),

          UserHomeScreen(user: widget.user),

          /// WIDGET: BACK LAYER BOTTOM NAVBAR
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70.r,
              decoration: BoxDecoration(
                color: whitePure,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFCCCCCC),
                    blurRadius: 20,
                    offset: Offset(6, 0),
                    spreadRadius: -5,
                  ),
                ],
              ),
            ),
          ),

          /// WIDGET: HALF CIRCLE BOTTOM BAR
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     width: 70.r,
          //     height: 70.r,
          //     margin: EdgeInsets.only(
          //       bottom: 20.r,
          //     ),
          //     decoration: BoxDecoration(
          //       color: whitePure,
          //       shape: BoxShape.circle,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Color(0xFFCCCCCC),
          //           blurRadius: 20,
          //           offset: Offset(6, 0),
          //           spreadRadius: -5,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          /// WIDGET: BOTTOM NAVIGATION BAR
          generateBottomNavbar(),
        ],
      ),
    );
  }

  Widget generateBottomNavbar() {
    List<Widget> pages = [
      UserProfileScreen(user: widget.user),
      UserTransactionScreen(user: widget.user),
    ];

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 70.r,
        decoration: BoxDecoration(
          color: whitePure,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.r),
            topRight: Radius.circular(10.r),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedFontSize: 12.sp,
          unselectedFontSize: 12.sp,
          selectedItemColor: blackPure,
          unselectedItemColor: blackPure,
          selectedLabelStyle: boldRobotoFont,
          unselectedLabelStyle: mediumRobotoFont,
          onTap: (index) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => pages[index],
            ));
          },
          items: [
            BottomNavigationBarItem(
              label: "Profil",
              icon: Container(
                margin: EdgeInsets.only(bottom: 6.r),
                height: 30.h,
                child: Image.asset(
                  "assets/images/icon_profil.png",
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "Transaksi",
              icon: Container(
                margin: EdgeInsets.only(bottom: 6.r),
                height: 30.h,
                child: Image.asset(
                  "assets/images/icon_transaksi.png",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
