import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/color.dart';
import '../../shared/font.dart';
import '../screens/admin/admin_main_screen.dart';
import 'user/home/user_main_screen.dart';
import '../screens/auth/login_screen.dart';
import '../../models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseUser = FirebaseAuth.instance;

    CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');

    if (firebaseUser.currentUser != null) {
      return Scaffold(
        backgroundColor: darkGreen,
        body: StreamBuilder<DocumentSnapshot<Object?>>(
          stream:
              userRef.doc(firebaseUser.currentUser!.uid.toString()).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User user =
                  User.fromJson(snapshot.data!.data() as Map<String, dynamic>);
              if (user.role == 'user') {
                return MainScreen(user: user);
              }
              if (user.role == 'petugas') {
                return AdminMainScreen(user: user);
              }
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: yellowPure,
                  ),
                  Text(
                    'Mohon tunggu..',
                    style: boldRobotoFont.copyWith(
                      fontSize: 14.sp,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
    }
    return LoginScreen();
  }
}
