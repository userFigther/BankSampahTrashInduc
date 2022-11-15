import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Contants Media Query

double defaultMargin = 24.r;

double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

double deviceHeight(BuildContext context) => MediaQuery.of(context).size.height;

double defaultWidth(BuildContext context) => deviceWidth(context) - 2 * defaultMargin;

double statusBarHeight(BuildContext context) => MediaQuery.of(context).padding.top;

Orientation getOrientation(BuildContext context) => MediaQuery.of(context).orientation;