import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:trash_induc/ui/screens/admin/transaksi/add_cart_item_screen.dart';
import 'package:trash_induc/ui/screens/admin/transaksi/edit_cart_item_screen.dart';
import 'package:trash_induc/ui/widgets/snackbar.dart';

import '../../../../models/cart_item.dart';
import '../../../../models/mission.dart';
import '../../../../models/user.dart';
import '../../../../repository/transaction_repository.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';

class AdminAddTransactionScreen extends StatefulWidget {
  const AdminAddTransactionScreen({Key? key}) : super(key: key);
  static String routeName = '/officer_add_transaction';

  @override
  _AdminAddTransactionScreenState createState() =>
      _AdminAddTransactionScreenState();
}

class _AdminAddTransactionScreenState extends State<AdminAddTransactionScreen> {
  GlobalKey<FormFieldState> key = GlobalKey<FormFieldState>();

  Future<List<User>>? fetchUsers;
  Future<Map<String, Mission>>? fetchMissions;

  Future<List<User>> _fetchUsers() async {
    var users = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'user')
        .get();
    return users.docs.map((e) => User.fromJson(e.data())).toList();
  }

  Future<List<Mission>> _fetchMissions(String userId) async {
    var completedMissionsByUser = await FirebaseFirestore.instance
        .collection('user_completed_missions')
        .where('user_id', isEqualTo: userId)
        .get();
    var completedMissionIds = completedMissionsByUser.docs
        .map((e) => e.exists ? e.data()['mission_id'] : null)
        .toList();

    QuerySnapshot<Map<String, dynamic>> missions;
    if (completedMissionIds.isNotEmpty) {
      missions = await FirebaseFirestore.instance
          .collection('missions')
          .where('is_active', isEqualTo: true)
          .where('hidden', isEqualTo: false)
          .where('id', whereNotIn: completedMissionIds)
          .get();
    } else {
      missions = await FirebaseFirestore.instance
          .collection('missions')
          .where('is_active', isEqualTo: true)
          .where('hidden', isEqualTo: false)
          .get();
    }

    return missions.docs.map((e) => Mission.fromJson(e.data())).toList();
  }

  @override
  void initState() {
    fetchUsers = _fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreen,
        leading: IconButton(
            onPressed: () {
              final repository = Provider.of<TransactionRepository>(
                context,
                listen: false,
              );
              Navigator.of(context).pop();
              repository.removeAllItem();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_sharp,
            )),
        automaticallyImplyLeading: false,
        title: Text(
          'Input transaksi',
          style: boldRobotoFont.copyWith(
            fontSize: 14.sp,
          ),
        ),
        titleSpacing: 0,
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 6.w,
        ),
        height: 155.h,
        decoration: BoxDecoration(
            border: Border.all(
                color: blackPure.withOpacity(
              0.4,
            )),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  15.r,
                ),
                topRight: Radius.circular(
                  15.r,
                ))),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Exp yg didapat:'),
                Consumer<TransactionRepository>(
                    builder: (context, repository, child) {
                  return Text(
                    repository.getTotalXp().toString(),
                  );
                })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Balance yg didapat:'),
                Consumer<TransactionRepository>(
                    builder: (context, repository, child) {
                  return Text(
                    repository.getTotalBalance().toString(),
                  );
                })
              ],
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: darkGreen,
                ),
                onPressed: () {
                  submitData();
                },
                child: Text(
                  'Tambah Data',
                )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 8.w,
        ),
        child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Users:',
                  style: regularRobotoFont.copyWith(
                    fontSize: 10.sp,
                    color: blackPure,
                  ),
                ),
                FutureBuilder<List<User>>(
                    future: fetchUsers,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      return DropdownSearch<User>(
                        mode: Mode.MENU,
                        onFind: (String? filter) async {
                          if (filter == null || filter == '') {
                            var users = await FirebaseFirestore.instance
                                .collection('users')
                                .where('role', isEqualTo: 'user')
                                .get();
                            return users.docs
                                .map((e) => User.fromJson(e.data()))
                                .toList();
                          }

                          var getUsersByEmail = await FirebaseFirestore.instance
                              .collection('users')
                              .where('role', isEqualTo: 'user')
                              .where('email', isGreaterThanOrEqualTo: filter)
                              .where('email', isLessThan: filter + 'z')
                              .get();

                          var users = getUsersByEmail.docs;

                          return users
                              .map((e) => User.fromJson(e.data()))
                              .toList();
                        },
                        itemAsString: (User? user) => user!.email.toString(),
                        showSearchBox: true,
                        onChanged: (User? user) {
                          if (user == null) {
                            return;
                          }

                          final repository = Provider.of<TransactionRepository>(
                              context,
                              listen: false);
                          repository.setUserId(user.id.toString());
                          repository.setFutureListMission(
                              _fetchMissions(user.id.toString()));
                        },
                      );
                    }),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Items:',
                      style: regularRobotoFont.copyWith(
                        fontSize: 10.sp,
                        color: blackPure,
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: darkGreen,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CartItemFormScreen(),
                          ));
                        },
                        child: Icon(
                          Icons.add,
                        ))
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Consumer<TransactionRepository>(
                        builder: (context, repository, child) {
                      List<CartItem> items = repository.cartItems;
                      return DataTable(
                        columns: [
                          DataColumn(
                              label: SizedBox(
                            width: 60.w,
                            child: Text(
                              'Jenis',
                            ),
                          )),
                          DataColumn(
                              label: SizedBox(
                            width: 60.w,
                            child: Text(
                              'Berat(kg)',
                            ),
                          )),
                          DataColumn(
                              label: SizedBox(
                            width: 60.w,
                            child: Text(
                              'Harga',
                            ),
                          )),
                          DataColumn(
                              label: Text(
                            '',
                          ))
                        ],
                        rows: items.isNotEmpty
                            ? itemNotEmpty(items)
                            : itemEmpty(),
                      );
                    })),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Pilih misi yang dicapai:',
                  style: regularRobotoFont.copyWith(
                    fontSize: 10.sp,
                    color: blackPure,
                  ),
                ),
                Consumer<TransactionRepository>(
                    builder: (context, repository, child) {
                  if (repository.userId == '') {
                    return Text('Silahkan pilih user terlebih dahulu');
                  }
                  return FutureBuilder<List<Mission>>(
                      future: repository.futureListMission,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasData) {
                          final repository = Provider.of<TransactionRepository>(
                              context,
                              listen: false);

                          if (snapshot.data!.isNotEmpty) {
                            return MultiSelectDialogField(
                                chipDisplay: MultiSelectChipDisplay(
                                  scroll: true,
                                  chipColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                items: snapshot.data!
                                    .map(
                                      (e) => MultiSelectItem(
                                        e,
                                        e.name.toString(),
                                      ),
                                    )
                                    .toList(),
                                onConfirm: (value) {
                                  repository.setMissions(value.cast<Mission>());
                                });
                          } else {
                            return Text(
                                'Tidak ada misi yang bisa diselesaikan');
                          }
                        }

                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        return SizedBox();
                      });
                }),
                Consumer(builder: (context, repository, child) {
                  final repository =
                      Provider.of<TransactionRepository>(context);
                  return ListTile(
                    title: Text(
                      'Sampah sudah dipisah',
                    ),
                    leading: Checkbox(
                        value: repository.isSampahChecked,
                        onChanged: (bool? value) {
                          repository.setCheckBox(value!);
                        }),
                  );
                })
              ],
            )),
      ),
    );
  }

  Future<dynamic> submitData() async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      final repository =
          Provider.of<TransactionRepository>(context, listen: false);

      var userRef =
          FirebaseFirestore.instance.collection('users').doc(repository.userId);
      var user = await userRef.get();
      var userData = User.fromJson(user.data()!);

      var pegawaiRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      var pegawaiData = User.fromJson(pegawaiRef.data()!);

      if (!user.exists) {
        throw Exception('User tidak ditemukan');
      }

      double totalExp = 0;
      double totalBalance = 0;
      double totalSell = 0;

      var transaction =
          await FirebaseFirestore.instance.collection('transactions').add({
        'created_at': DateTime.now(),
        'user': userData.toJson(),
        'petugas': pegawaiData.toJson(),
      });

      for (var cart in repository.cartItems) {
        await FirebaseFirestore.instance.collection('transaction_items').add({
          'transaction_id': transaction.id,
          'item': cart.item.toJson(),
          'qty': cart.qty
        });
        totalExp += cart.item.exp_point! * cart.qty;
        totalBalance += cart.item.balance_point! * cart.qty;
        totalSell += cart.item.sell! * cart.qty;
      }

      if (repository.missions.isNotEmpty) {
        var listMissions = await FirebaseFirestore.instance
            .collection('missions')
            .where(FieldPath.documentId,
                whereIn: repository.missions.map((m) => m.id).toList())
            .get();

        if (listMissions.docs.length != repository.missions.length) {
          throw Exception(
              'Data misi tidak valid Silahkan coba buka ulang fitur tambah transaksi');
        }

        for (var mission in repository.missions) {
          await FirebaseFirestore.instance
              .collection('user_completed_missions')
              .doc('${repository.userId}_${mission.id}')
              .set({
            'created_at': DateTime.now(),
            'user_id': repository.userId,
            'transaction_id': transaction.id,
            'mission_id': mission.id,
          });

          totalExp += mission.exp!;
          totalBalance += mission.balance!;
        }
      }

      if (repository.isSampahChecked) {
        var bonusMilahSampah = await FirebaseFirestore.instance
            .collection('missions')
            .doc('bonus-milah-sampah')
            .get();

        if (bonusMilahSampah.exists) {
          var bonusData = Mission.fromJson(bonusMilahSampah.data()!);
          totalBalance += bonusData.balance!;
          totalExp += bonusData.exp!;
        }
      }

      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(transaction.id)
          .update({
        'total_balance': totalSell + totalBalance,
        'total_exp': totalExp,
      });

      await userRef.update({
        'exp': totalExp + userData.exp!,
        'balance': totalBalance + userData.balance! + totalSell,
      });

      return true;
    }).then((value) {
      final repository = Provider.of<TransactionRepository>(
        context,
        listen: false,
      );
      CustomSnackbar.buildSnackbar(context, 'berhasil menambah transaksi', 1);
      Navigator.of(context).pop();
      repository.removeAllItem();
    });
  }

  List<DataRow> itemEmpty() {
    return [
      DataRow(cells: [
        DataCell(Text(
          '-',
        )),
        DataCell(Text(
          '-',
        )),
        DataCell(Text(
          '-',
        )),
        DataCell(Row(
          children: [
            IconButton(onPressed: null, icon: SizedBox()),
            IconButton(onPressed: null, icon: SizedBox())
          ],
        ))
      ])
    ];
  }

  List<DataRow> itemNotEmpty(List<CartItem> items) {
    List<DataRow> dataRows = [];
    final repoTrans =
        Provider.of<TransactionRepository>(context, listen: false);
    items.forEach((CartItem item) => dataRows.add(DataRow(cells: [
          DataCell(
            Text(item.item.name.toString()),
          ),
          DataCell(Text(
            item.qty.toString(),
          )),
          DataCell(Text(
            item.getTotalPrice().toString(),
          )),
          DataCell(Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditCartItemFormScreen(item),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: darkGreen,
                  )),
              IconButton(
                  onPressed: () {
                    repoTrans.removeItem(item);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: redDanger,
                  ))
            ],
          ))
        ])));

    return dataRows;
  }
}
