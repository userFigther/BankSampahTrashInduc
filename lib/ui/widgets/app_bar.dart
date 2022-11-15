import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/color.dart';
import '../../shared/font.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);
  String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: darkGreen,
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
          )),
      title: Text(
        title,
        style: boldRobotoFont.copyWith(
          fontSize: 14.sp,
        ),
      ),
      titleSpacing: 0,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
