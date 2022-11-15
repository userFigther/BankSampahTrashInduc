import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/color.dart';

class LoadingBar extends StatelessWidget {
  final double? size;
  final Color? color;

  LoadingBar({
    this.size,
    this.color = whitePure,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 28.r,
      height: size ?? 28.r,
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  }
}