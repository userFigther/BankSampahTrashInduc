import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButton extends StatelessWidget {
  final String image;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final void Function()? onPressed;

  SocialButton({
    this.height,
    this.color,
    this.borderRadius,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 46.r,
      padding: EdgeInsets.symmetric(
        horizontal: 16.r,
      ),
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
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.r,
          ),
          child: Image(
            width: 22.r,
            height: 22.r,
            fit: BoxFit.cover,
            image: AssetImage(image),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
