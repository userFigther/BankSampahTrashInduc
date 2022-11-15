import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/item.dart';
import '../../shared/color.dart';
import '../../shared/font.dart';

class PriceCard extends StatelessWidget {
  final String title;
  final List<Color> color;
  final List<Item> data;

  PriceCard({
    Key? key,
    required this.title,
    required this.color,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 0.25.sh,
          width: 0.45.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10.r,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0,
                0.7,
                1,
              ],
              colors: [
                color[0],
                color[1],
                color[0],
              ],
            ),
          ),
          child: Opacity(
            opacity: 0.3,
            child: Image.asset(
              "assets/images/bg_jual_sampah.png",
            ),
          ),
        ),
        Row(
          children: [
            Text(
              "Harga\n$title",
              textAlign: TextAlign.center,
              style: boldRobotoFont.copyWith(
                fontSize: 11.sp,
                color: title == "Jual" ? Color(0xff92840F) : Color(0xff00A3FF),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            SizedBox(
                height: 0.2.sh,
                width: 0.3.sw,
                child: ListView.builder(
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var listData = data[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: 10.w,
                      ),
                      child: Column(
                        children: [
                          Text(
                            listData.name!,
                            style: mediumRobotoFont.copyWith(
                              color: title == "Jual"
                                  ? Color(0xff92840F)
                                  : Color(0xff00A3FF),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: 7.w,
                            ),
                            child: Text(
                              "Rp",
                              style: regularRobotoFont.copyWith(
                                color: blackPure,
                              ),
                            ),
                          ),
                          Text(
                            title == "Jual"
                                ? listData.sell.toString()
                                : listData.buy.toString(),
                            style: boldRobotoFont.copyWith(
                              color: blackPure,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 7.w,
                            ),
                            child: Text(
                              "kg",
                              style: regularRobotoFont.copyWith(
                                color: blackPure,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ))
          ],
        )
      ],
    );
  }
}
