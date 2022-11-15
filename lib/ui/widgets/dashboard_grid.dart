import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/color.dart';
import '../../shared/font.dart';

class DashboardGrid extends StatelessWidget {
  DashboardGrid({
    Key? key,
    required this.data,
    required this.icon,
    required this.label,
  }) : super(key: key);

  int data;
  IconData icon;
  String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: whitePure,
          borderRadius: BorderRadius.circular(
            15.r,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            data.toString(),
            style: mediumRobotoFont.copyWith(
              fontSize: 18.sp,
              color: darkGreen,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Icon(
            icon,
            color: darkGreen,
            size: 50.r,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: regularRobotoFont.copyWith(
              fontSize: 10.sp,
              color: darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}
