import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../models/reedemed_reward.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';

class UserReedemedScreen extends StatefulWidget {
  UserReedemedScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  String id;

  @override
  _UserReedemedScreenState createState() => _UserReedemedScreenState();
}

class _UserReedemedScreenState extends State<UserReedemedScreen> {
  Stream<List<RedeemedReward>> _fetchRedeemedRewards() {
    var redeemedRewards = FirebaseFirestore.instance
        .collection('user_redeemed_rewards')
        .where("user.id", isEqualTo: widget.id)
        .snapshots();
    return redeemedRewards.map(
      (event) => event.docs
          .map((e) => RedeemedReward.fromJson(e.data(), id: e.id))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<List<RedeemedReward>>(
          stream: _fetchRedeemedRewards(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    RedeemedReward redeemedReward = snapshot.data![index];

                    return Stack(children: [
                      Card(
                          elevation: 4,
                          child: Stack(children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              height: 105.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                5.r,
                              )),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 80.h,
                                    width: 80.w,
                                    child: redeemedReward.reward!.photoUrl == ""
                                        ? Image.asset(
                                            "assets/images/placeholder-image.png")
                                        : CachedNetworkImage(
                                            imageUrl: redeemedReward
                                                .reward!.photoUrl!,
                                          ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 130.w,
                                        child: Text(
                                          redeemedReward.reward!.name!,
                                          style: mediumRobotoFont.copyWith(
                                            fontSize: 16.sp,
                                            color: blackPure,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Ditukar pada " +
                                            DateFormat.yMd()
                                                .format(new DateTime
                                                        .fromMicrosecondsSinceEpoch(
                                                    redeemedReward.created_at!
                                                        .microsecondsSinceEpoch))
                                                .toString(),
                                        style: regularRobotoFont.copyWith(
                                          fontSize: 11.sp,
                                          color: blackPure,
                                        ),
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: BorderSide(
                                            color: darkGreen,
                                          ),
                                          primary: whitePure,
                                          elevation: 0,
                                        ),
                                        onPressed: null,
                                        child: Text(
                                          redeemedReward.status == "pending"
                                              ? "Menunggu"
                                              : "Selesai",
                                          style: boldRobotoFont.copyWith(
                                            fontSize: 13.sp,
                                            color: darkGreen,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            if (redeemedReward.created_at!.toDate() ==
                                DateTime.now())
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 40.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                            5.r,
                                          ),
                                          bottomLeft: Radius.circular(
                                            5.r,
                                          ))),
                                  child: Center(
                                      child: Text(
                                    "New",
                                    style: boldRobotoFont.copyWith(
                                      fontSize: 14.sp,
                                      color: whitePure,
                                    ),
                                  )),
                                ),
                              )
                          ])),
                    ]);
                  });
            }

            return CircularProgressIndicator(
              color: darkGreen,
            );
          }),
    );
  }
}
