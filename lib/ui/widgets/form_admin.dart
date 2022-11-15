import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/color.dart';
import '../../shared/font.dart';

class FormAdmin extends StatelessWidget {
  final bool? readOnly;
  final String? initial;
  final String? label;
  final TextInputAction? action;
  final TextEditingController? controller;
  final TextInputType? type;

  FormAdmin({
    this.readOnly = false,
    this.initial,
    required this.label,
    this.action = TextInputAction.next,
    this.controller,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: boldRobotoFont.copyWith(
            fontSize: 10.sp,
            color: darkGray,
          ),
        ),
        TextFormField(
          readOnly: readOnly!,
          initialValue: initial,
          keyboardType: type,
          textInputAction: action,
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
              8.r,
            )),
            isDense: true,
          ),
        ),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }
}
