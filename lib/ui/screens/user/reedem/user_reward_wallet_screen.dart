import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../models/reedemed_reward.dart';
import '../../../../models/reward.dart';
import '../../../../models/user.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/snackbar.dart';

class UserRewardWalletScreen extends StatefulWidget {
  UserRewardWalletScreen({
    Key? key,
    required this.user,
    required this.id,
  }) : super(key: key);

  User user;
  String id;

  @override
  UserRewardWalletScreenState createState() => UserRewardWalletScreenState();
}

class UserRewardWalletScreenState extends State<UserRewardWalletScreen> {
  Stream<List<Reward>> _fetchRewards() {
    var rewards = FirebaseFirestore.instance
        .collection('rewards')
        .where(
          'expired_at',
          isGreaterThanOrEqualTo: DateTime.now(),
        )
        .snapshots();
    return rewards.map(
      (event) => event.docs.map((e) => Reward.fromJson(e.data())).toList(),
    );
  }

  Stream<List<RedeemedReward>> _filterReward() {
    var results = FirebaseFirestore.instance
        .collection("user_redeemed_rewards")
        .where("user.id", isEqualTo: widget.id)
        .snapshots();

    return results.map(
      (event) => event.docs
          .map((e) => RedeemedReward.fromJson(e.data(), id: e.id))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<List<RedeemedReward>>(
        stream: _filterReward(),
        builder: (BuildContext context,
            AsyncSnapshot<List<RedeemedReward>> redeemedSnapshot) {
          if (redeemedSnapshot.hasData) {
            return StreamBuilder<List<Reward>>(
              stream: _fetchRewards(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Reward>> rewardSnapshot) {
                if (rewardSnapshot.hasData) {
                  List<String?> rewardId =
                      redeemedSnapshot.data!.map((e) => e.reward!.id).toList();
                  List<Reward> rewards = rewardSnapshot.data!;

                  rewards
                      .removeWhere((element) => rewardId.contains(element.id));

                  if (rewardSnapshot.data!.isEmpty) {
                    return Text("Kosong");
                  }
                  return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      itemCount: rewardSnapshot.data!.length,
                      itemBuilder: (context, index) {
                        Reward reward = rewardSnapshot.data![index];

                        return Stack(children: [
                          Card(
                              elevation: 5,
                              child: Stack(children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  height: 115.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                    5.r,
                                  )),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 4,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height: 80.h,
                                            width: 80.w,
                                            child: reward.photoUrl == ""
                                                ? Image.asset(
                                                    "assets/images/placeholder-image.png")
                                                : CachedNetworkImage(
                                                    imageUrl: reward.photoUrl!,
                                                  )),
                                        SizedBox(
                                          width: 14.w,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                reward.name!,
                                                style: boldRobotoFont.copyWith(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w900,
                                                  color: blackPure,
                                                  height: 1,
                                                ),
                                              ),
                                              Text(
                                                "Exp " +
                                                    DateFormat.yMd()
                                                        .format(new DateTime
                                                                .fromMicrosecondsSinceEpoch(
                                                            reward.expired_at!
                                                                .microsecondsSinceEpoch))
                                                        .toString(),
                                                style:
                                                    regularRobotoFont.copyWith(
                                                  fontSize: 11.sp,
                                                  color: blackPure,
                                                ),
                                              ),
                                              Spacer(),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            elevation: (widget
                                                                        .user
                                                                        .balance! <
                                                                    reward
                                                                        .cost!)
                                                                ? 0
                                                                : 5,
                                                            primary: whitePure,
                                                            side: BorderSide(
                                                              width: 1,
                                                              color: (widget
                                                                          .user
                                                                          .balance! <
                                                                      reward
                                                                          .cost!)
                                                                  ? whitePure
                                                                  : blueSky,
                                                            )),
                                                    onPressed:
                                                        (widget.user.balance! <
                                                                reward.cost!)
                                                            ? null
                                                            : () => showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    content: SingleChildScrollView(
                                                                        child: Text("Anda akan menukarkan " +
                                                                            reward.cost.toString() +
                                                                            " poin untuk hadiah " +
                                                                            reward.name! +
                                                                            ", yakin?")),
                                                                    title: Text(
                                                                        "Konfirmasi penukaran hadiah"),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            "Tidak"),
                                                                      ),
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          proceedRedeem(
                                                                            widget.user,
                                                                            reward,
                                                                            widget.id,
                                                                          );
                                                                        },
                                                                        child: Text(
                                                                            "Iya"),
                                                                      ),
                                                                    ],
                                                                  );
                                                                }),
                                                    child: Text(
                                                      "Reedem " +
                                                          reward.cost
                                                              .toString(),
                                                      style: boldRobotoFont
                                                          .copyWith(
                                                        fontSize: 13.sp,
                                                        color: (widget.user
                                                                    .balance! <
                                                                reward.cost!)
                                                            ? blackPure
                                                                .withOpacity(
                                                                0.7,
                                                              )
                                                            : blueSky,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (reward.created_at!.toDate() ==
                                    DateTime.now())
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      width: 35.w,
                                      height: 15.h,
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
                                          fontSize: 12.sp,
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
              },
            );
          }

          return CircularProgressIndicator(
            color: darkGreen,
          );
        },
      ),
    );
  }

  Future proceedRedeem(User user, Reward reward, String id) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      var dataPetugas = User(
        role: "petugas",
        membership: "",
      );
      var redeemRef =
          FirebaseFirestore.instance.collection("user_redeemed_rewards");
      var userRef = FirebaseFirestore.instance.collection("users").doc(id);
      var userDataRef = await userRef.get();
      var userData = User.fromJson(
        userDataRef.data()!,
      );
      var balance = user.balance! - reward.cost!;

      await redeemRef.add({
        "user": userData.toJson(),
        "petugas": dataPetugas.toJson(),
        "reward": reward.toJson(),
        "status": "pending",
        "created_at": DateTime.now(),
        "updated_at": DateTime.now(),
      });

      await userRef.update({
        "balance": balance,
      });

      return true;
    }).then((value) {
      if (value) {
        Navigator.of(context).pop();
        CustomSnackbar.buildSnackbar(
            context, "Berhasil mengajukan penukaran hadiah", 1);
      }
    }).catchError((error) => CustomSnackbar.buildSnackbar(
          context,
          "Terjadi kesalahan: ${error.toString()}",
          0,
        ));
  }
}
