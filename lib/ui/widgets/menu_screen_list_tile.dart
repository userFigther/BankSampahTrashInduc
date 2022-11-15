import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/color.dart';
import '../../shared/font.dart';

class CustomMenuScreenListTile extends StatelessWidget {
  final String imageLeading;
  final String title;
  final Color backgroundColor;

  const CustomMenuScreenListTile({
    Key? key,
    required this.imageLeading,
    required this.title,
    this.backgroundColor = whitePure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 5.w,
      ),
      height: 45.w,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(
            10.r,
          )),
      child: ListTile(
        dense: true,
        leading: Image(
          image: AssetImage(
            imageLeading,
          ),
        ),
        title: Text(
          title,
          style: boldRobotoFont.copyWith(
            fontSize: 16.sp,
            color: blackPure,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: blackPure,
        ),
      ),
    );
  }
}
