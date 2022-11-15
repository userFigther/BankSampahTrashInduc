import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trash_induc/shared/color.dart';
import 'package:trash_induc/shared/font.dart';
import 'package:trash_induc/ui/screens/wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const Wrapper(),
            )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                Image.asset('assets/images/splash.png', height: 200.sp),
                Text(
                  "Trash Induc",
                  textAlign: TextAlign.center,
                  style: regularRobotoFont.copyWith(
                    fontSize: 14.sp,
                    color: whitePure,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
