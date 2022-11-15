import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trash_induc/ui/screens/admin/reward/add_reward_screen.dart';
import 'package:trash_induc/ui/screens/admin/reward/detail_reward_screen.dart';
import 'package:trash_induc/ui/screens/admin/reward/edit_reward_screen.dart';

import '../../../../models/reward.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../../utils/const.dart';
import '../../../widgets/admin_drawer.dart';
import '../../../widgets/snackbar.dart';

class AdminIndexRewardScreen extends StatefulWidget {
  const AdminIndexRewardScreen({Key? key}) : super(key: key);
  static String routeName = '/admin_index_reward';

  @override
  _AdminIndexRewardScreenState createState() => _AdminIndexRewardScreenState();
}

class _AdminIndexRewardScreenState extends State<AdminIndexRewardScreen> {
  int dropdownValue = 10;
  TextEditingController searchController = TextEditingController();
  List<int> dropdownValues = [
    10,
    25,
    50,
  ];

  Future<List<Reward>>? _futureRewards;

  Future<List<Reward>> _filterRewards() async {
    var rewards = <Reward>[];

    if (searchController.text.trim() != '') {
      var searchQuery = searchController.text.trim().toLowerCase();
      var rewardName = await FirebaseFirestore.instance
          .collection('rewards')
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThan: searchQuery + 'z')
          .get();

      var data = [];
      data.addAll(rewardName.docs);
      rewards.addAll(data.map((e) => Reward.fromJson(e.data())).toList());
    } else {
      var result = await FirebaseFirestore.instance.collection('rewards').get();
      rewards = result.docs.map((e) => Reward.fromJson(e.data())).toList();
    }

    return rewards;
  }

  void refresh() {
    setState(() {
      _futureRewards = _filterRewards();
    });
  }

  @override
  void initState() {
    super.initState();
    _futureRewards = _filterRewards();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawer(),
      appBar: AppBar(
        backgroundColor: darkGreen,
        leading: Builder(
          builder: (context) {
            return IconButton(
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              icon: Image.asset(
                'assets/images/buttonSidebar.png',
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        title: Text(
          'Reward',
          style: boldRobotoFont.copyWith(
            fontSize: 14.sp,
          ),
        ),
        titleSpacing: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AdminAddRewardScreen(),
              ));
              refresh();
            },
            icon: Image.asset('assets/images/buttonCreate.png'),
          )
        ],
      ),
      body: ListView(children: [
        FutureBuilder<List<Reward>>(
          future: _futureRewards,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PaginatedDataTable(
                header: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(
                          fontSize: 10.sp,
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _futureRewards = _filterRewards();
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                              8.r,
                            )),
                            hintText: 'Cari reward',
                            prefixIcon: Icon(
                              Icons.search,
                              size: 28,
                              color: lightGreen,
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 13.h,
                    ),
                    DropdownButton<int>(
                      elevation: 2,
                      value: dropdownValue,
                      icon: Icon(
                        Icons.visibility,
                        size: 18,
                      ),
                      items: dropdownValues.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(
                            value.toString(),
                          ),
                        );
                      }).toList(),
                      onChanged: (int? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                columns: [
                  DataColumn(
                    label: Text('No'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Nama'),
                  ),
                  DataColumn(
                    label: Text('Harga'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Expired'),
                  ),
                  DataColumn(
                    label: Text('Aksi'),
                  ),
                ],
                source: AdminDataReward(
                  context: context,
                  data: snapshot.data!,
                  parent: this,
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: darkGreen,
              ),
            );
          },
        ),
      ]),
    );
  }
}

class AdminDataReward extends DataTableSource {
  final List<Reward> data;
  final BuildContext context;
  final _AdminIndexRewardScreenState parent;

  AdminDataReward({
    required this.parent,
    required this.data,
    required this.context,
  });

  detailPage(Reward reward) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AdminDetailRewardScreen(
        reward: reward,
      ),
    ));
  }

  deleteReward(String url, Reward reward) async {
    final storageRef = FirebaseStorage.instance;
    final rewardRef = FirebaseFirestore.instance.collection('rewards');
    try {
      if (reward.photoUrl != '') {
        await storageRef.refFromURL(url).delete();
      }
      await rewardRef.doc(reward.id).delete();
      parent.refresh();
      Navigator.pop(context);
      CustomSnackbar.buildSnackbar(
          context, 'Berhasil menghapus reward: ${reward.name}', 1);
    } catch (e) {
      CustomSnackbar.buildSnackbar(context, 'Gagal menghapus reward: $e', 0);
    }
  }

  @override
  DataRow? getRow(int index) {
    Reward reward = data[index];
    return DataRow(cells: [
      DataCell(
        Text((index + 1).toString()),
        onTap: () => detailPage(reward),
      ),
      DataCell(
        Text(
          reward.name!,
        ),
        onTap: () => detailPage(reward),
      ),
      DataCell(
        Text(
          reward.cost.toString(),
        ),
        onTap: () => detailPage(reward),
      ),
      DataCell(
        Text(
          dateFormat.format(reward.created_at!.toDate()),
        ),
        onTap: () => detailPage(reward),
      ),
      DataCell(
        Row(
          children: [
            IconButton(
                splashRadius: 15,
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AdminEditRewardScreen(
                      reward: reward,
                      copyOfUrl: reward.photoUrl!,
                    ),
                  ));
                  parent.refresh();
                },
                icon: Icon(
                  Icons.edit,
                  color: darkGreen,
                )),
            IconButton(
                splashRadius: 15,
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: RichText(
                            text: TextSpan(
                                text: 'Anda yakin ingin menghapus ',
                                style: regularRobotoFont.copyWith(
                                  fontSize: 14.sp,
                                  color: darkGreen,
                                ),
                                children: [
                                  TextSpan(
                                    text: reward.name,
                                    style: boldRobotoFont.copyWith(
                                      fontSize: 14.sp,
                                      color: darkGreen,
                                    ),
                                  ),
                                  TextSpan(
                                      text: '?',
                                      style: regularRobotoFont.copyWith(
                                        fontSize: 14.sp,
                                        color: darkGreen,
                                      ))
                                ]),
                          ),
                          actions: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: whitePure,
                                    side: BorderSide(
                                      color: darkGreen,
                                    )),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Batal',
                                    style: mediumRobotoFont.copyWith(
                                      fontSize: 12.sp,
                                      color: darkGreen,
                                    ))),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: darkGreen,
                                ),
                                onPressed: () {
                                  deleteReward(
                                    reward.photoUrl!,
                                    reward,
                                  );
                                },
                                child: Text('Ya, saya yakin',
                                    style: mediumRobotoFont.copyWith(
                                      fontSize: 12.sp,
                                    )))
                          ],
                        );
                      });
                },
                icon: Icon(
                  Icons.delete,
                  color: redDanger,
                ))
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
