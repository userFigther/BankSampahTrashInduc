import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import 'user_redeemed_screen.dart';
import 'user_reward_wallet_screen.dart';
import '../../../widgets/menu_screen_card.dart';
import '../../../../models/user.dart';

class UserRedeemScreen extends StatefulWidget {
  static String routeName = "/reedem";

  UserRedeemScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  String id;

  @override
  _UserRedeemScreenState createState() => _UserRedeemScreenState();
}

class _UserRedeemScreenState extends State<UserRedeemScreen> {
  CollectionReference userRef = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: whitePure,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: darkGreen,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: Text(
                  "Menu",
                  style: regularRobotoFont.copyWith(
                    fontSize: 14.sp,
                    color: darkGreen,
                  ),
                ),
              ),
              SizedBox(
                width: 60.w,
              ),
              Center(
                child: Text(
                  "Tukar Poin",
                  style: boldRobotoFont.copyWith(
                    fontSize: 18.sp,
                    color: darkGreen,
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body:
            // BACKGROUND CONTAINER
            Container(
          height: 1.sh,
          color: darkGreen,
          child: Center(
            child: StreamBuilder(
              stream: userRef.doc(widget.id).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  User user = User.fromJson(
                    snapshot.data!.data() as Map<String, dynamic>,
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 0.02.sh,
                      ),
                      // CARD SECTION
                      Center(
                          child: MenuScreenCard(
                        assetPath: "assets/images/medal_backdrop.png",
                        type: "Balance",
                        point: user.balance!,
                      )),
                      SizedBox(
                        height: 0.01.sh,
                      ),
                      // TAB SECTION
                      DefaultTabController(
                          length: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: whitePure,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                          15.r,
                                        ),
                                        topRight: Radius.circular(
                                          15.r,
                                        ))),
                                child: TabBar(
                                  indicator: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: darkGreen,
                                    width: 5,
                                  ))),
                                  labelColor: blackPure,
                                  unselectedLabelColor: grayPure,
                                  tabs: [
                                    Tab(
                                      text: "Reward Wallet",
                                    ),
                                    Tab(
                                      text: "Redeemed",
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: whitePure,
                                height: 0.637.sh,
                                child: TabBarView(
                                  children: [
                                    UserRewardWalletScreen(
                                      user: user,
                                      id: widget.id,
                                    ),
                                    UserReedemedScreen(
                                      id: widget.id,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ))
                    ],
                  );
                }

                return CircularProgressIndicator(
                  color: whitePure,
                );
              },
            ),
          ),
        ));
  }
}
