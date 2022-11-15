import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trash_induc/models/user.dart';
import 'package:trash_induc/utils/const.dart';

import '../../../../models/item.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../../shared/size.dart';
import '../reedem/user_redeem_screen.dart';
import 'user_menu_screen.dart';
import '../../../widgets/garbage_card.dart';
import '../../../../extension/date_time_extension.dart';

class UserHomeScreen extends StatefulWidget {
  UserHomeScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  User user;

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final double width = 24.r;
  final List<Color> leftBarColor = [
    whitePure,
    whitePure,
  ];

  CollectionReference userRef = FirebaseFirestore.instance.collection("users");
  var itemRef = FirebaseFirestore.instance.collection("items").get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: FutureBuilder(
          future: userRef.doc(widget.user.id).get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              User user = User.fromJson(
                snapshot.data!.data() as Map<String, dynamic>,
              );
              return ListView(
                children: [
                  /// SECTION: HEADER PROFILE
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      defaultMargin,
                      18.r,
                      defaultMargin,
                      18.r,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hai,",
                              style: lightRobotoFont.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              user.name == "" ? "user" : user.name!,
                              style: boldRobotoFont.copyWith(
                                fontSize: 20.sp,
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/icon_toggle.png"),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UserMenuScreen(user: widget.user),
                            ));
                          },
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      defaultMargin,
                      0,
                      defaultMargin,
                      12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Balance anda",
                          style: regularRobotoFont.copyWith(
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rp ${numberFormat.format(user.balance)}',
                              style: mediumRobotoFont.copyWith(
                                fontSize: 18.sp,
                              ),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: lightGreen,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => UserRedeemScreen(
                                      id: widget.user.id!,
                                    ),
                                  ));
                                },
                                child: Text(
                                  "Tukar Reward",
                                  style: regularRobotoFont.copyWith(
                                    fontSize: 16.sp,
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// SECTION: TRANSACTION RECORD
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(
                  //       defaultMargin, 0, defaultMargin, 12.r),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         "Record Transaksi",
                  //         style: regularRobotoFont.copyWith(
                  //           fontSize: 16.sp,
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         height: 24.h,
                  //       ),

                  //       /// WIDGET: GRAPHIC BAR
                  //       Container(
                  //         width: defaultWidth(context),
                  //         height: 160.r,
                  //         padding: EdgeInsets.only(
                  //           left: 12.r,
                  //           right: 6.r,
                  //         ),
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.stretch,
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           mainAxisSize: MainAxisSize.max,
                  //           children: [
                  //             SizedBox(
                  //               height: 12.h,
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         children: [
                  //           Text(
                  //             "${getDateTime().dayName}, ${getDateTime().day} ${getDateTime().monthName} ${getDateTime().year}",
                  //             style: mediumRobotoFont,
                  //           ),
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // ),

                  /// SECTION: GARBAGE PRICE
                  FutureBuilder<QuerySnapshot<Object?>>(
                      future: itemRef,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Item> items = [];
                          for (var i in snapshot.data!.docs) {
                            items.add(Item.fromJson(
                                i.data() as Map<String, dynamic>));
                          }
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                                defaultMargin, 0, defaultMargin, 12.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Harga Sampah",
                                  style: regularRobotoFont.copyWith(
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                GarbageCard(
                                  title: "Jual",
                                  textColor: yellowPure,
                                  items: items,
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                GarbageCard(
                                  title: "Beli",
                                  textColor: blueSky,
                                  items: items,
                                ),
                              ],
                            ),
                          );
                        }
                        return CircularProgressIndicator(
                          color: lightGreen,
                        );
                      }),
                  SizedBox(
                    height: 80.h,
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return CircularProgressIndicator(
              color: darkGreen,
            );
          },
        ),
      ),
    );
  }

  /// Generate current user local daytime
  DateTime getDateTime() => DateTime.now();

  String getSideTitles(double value) {
    switch (value.toInt()) {
      case 1:
        return '0';
      case 2:
        return '25';
      case 3:
        return '50';
      case 4:
        return '75';
      case 5:
        return '100';
    }
    return '';
  }

  /// Generate short day name based on order number
  String getTitles(double value) {
    switch (value.toInt()) {
      case 0:
        return 'Min';
      case 1:
        return 'Sen';
      case 2:
        return 'Sel';
      case 3:
        return 'Rab';
      case 4:
        return 'Kam';
      case 5:
        return 'Jum';
      case 6:
        return 'Sab';
      default:
        return '';
    }
  }

  /// Generate bar chart group data widget

}
