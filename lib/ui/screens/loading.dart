import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trash_induc/ui/screens/wrapper.dart';

import '../../shared/color.dart';
import '../../shared/font.dart';
import '../../utils/firebase_utils.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({Key? key}) : super(key: key);

  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  Future signOutInit() async {
    await FirebaseUtils.signOut().then(
        (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => Wrapper(),
            )));
  }

  @override
  void initState() {
    signOutInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: darkGreen,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: whitePure,
            ),
            Text(
              "Mohon tunggu",
              style: regularRobotoFont.copyWith(
                fontSize: 18.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}
