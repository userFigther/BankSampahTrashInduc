import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/font.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final double? height;
  final Color? color;
  final Color? textColor;
  final void Function()? onPressed;

  ActionButton({
    this.height,
    this.text = "",
    this.color,
    this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: height ?? 46.r,
      child: MaterialButton(
        color: color,
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        splashColor: Colors.black.withOpacity(0.4),
        visualDensity: VisualDensity.comfortable,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(36.r),
        ),
        child: Text(
          text,
          style: boldCalibriFont.copyWith(
            fontSize: 16.sp,
            color: textColor,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
