import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/color.dart';
import '../../../shared/font.dart';
import '../../models/item.dart';

class GarbageCard extends StatelessWidget {
  final String title;
  final Color textColor;
  final List<Item> items;

  const GarbageCard({
    this.title = "",
    this.textColor = blackPure,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        decoration: BoxDecoration(
          color: whitePure,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 18.h,
              ),
              child: Opacity(
                opacity: 0.5,
                child: Image.asset("assets/images/bg_jual_sampah.png"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 18.w,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: whitePure,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 2.5.w,
                            color: textColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        "Harga $title",
                        style: mediumRobotoFont.copyWith(
                          color: textColor,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.1.sh,
                    width: 0.5.sw,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        Item item = items[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            right: 15,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                item.name!,
                                style: boldRobotoFont.copyWith(
                                  color: textColor,
                                  fontSize: 13.sp,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 18.r,
                                ),
                                child: Text(
                                  "Rp",
                                  textAlign: TextAlign.start,
                                  style: regularRobotoFont.copyWith(
                                    color: blackPure,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              Text(
                                title == "Jual"
                                    ? item.sell.toString()
                                    : item.buy.toString(),
                                style: boldRobotoFont.copyWith(
                                  color: blackPure,
                                  fontSize: 14.sp,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 18.r,
                                ),
                                child: Text(
                                  "Kg",
                                  textAlign: TextAlign.start,
                                  style: regularRobotoFont.copyWith(
                                    color: blackPure,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
