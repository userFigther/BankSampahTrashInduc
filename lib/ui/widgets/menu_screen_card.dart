import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/color.dart';
import '../../shared/font.dart';

class MenuScreenCard extends StatelessWidget {
  final String assetPath;
  final String type;
  final double point;
  const MenuScreenCard({
    Key? key,
    required this.assetPath,
    required this.type,
    required this.point,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82.h,
      color: Colors.transparent,
      child: Stack(children: [
        Container(
          width: 156.w,
          height: 72.h,
          decoration: BoxDecoration(
              color: whitePure,
              borderRadius: BorderRadius.circular(
                15.r,
              )),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                ),
                child: Image(
                  image: AssetImage(
                    assetPath,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 17.h,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Your " + type,
                        style: regularRobotoFont.copyWith(
                          fontSize: 9.sp,
                          color: darkGreen,
                        ),
                      ),
                      Text(
                        point.toString(),
                        style: boldRobotoFont.copyWith(
                          fontSize: 30.sp,
                          color: darkGreen,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
