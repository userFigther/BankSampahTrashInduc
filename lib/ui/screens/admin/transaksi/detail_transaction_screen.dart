import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trash_induc/utils/const.dart';

import '../../../../models/transaction.dart';
import '../../../../models/transaction_item.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/app_bar.dart';

class DetailTransactionScreen extends StatefulWidget {
  const DetailTransactionScreen({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  @override
  _DetailTransactionScreenState createState() =>
      _DetailTransactionScreenState();
}

class _DetailTransactionScreenState extends State<DetailTransactionScreen> {
  Future<DocumentSnapshot> _futureTransaction() async {
    return await FirebaseFirestore.instance
        .collection('transactions')
        .doc(widget.transaction.id!)
        .get();
  }

  Future<List<TransactionItem>> _futureTransactionItems(String id) async {
    var data = await FirebaseFirestore.instance
        .collection('transaction_items')
        .where('transaction_id', isEqualTo: id)
        .get();

    return data.docs
        .map((e) => TransactionItem.fromJson(
              e.data(),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Detail transaksi'),
      body: FutureBuilder<DocumentSnapshot>(
          future: _futureTransaction(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              Transaction transaction = Transaction.fromJson(
                  snapshot.data!.data() as Map<String, dynamic>,
                  id: widget.transaction.id);
              return ListView(
                padding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 8.w,
                ),
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: 50.w,
                    height: 75.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/splash.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Center(
                    child: Text(
                      'Trash induc',
                      style: boldRobotoFont.copyWith(
                        fontSize: 14.sp,
                        color: blackPure,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'ID: ' + transaction.id!,
                    style: mediumRobotoFont.copyWith(
                      fontSize: 12.sp,
                      color: blackPure,
                    ),
                  ),
                  Text(
                    'Tanggal: ' +
                        dateFormat.format(transaction.created_at!.toDate()),
                    style: mediumRobotoFont.copyWith(
                      fontSize: 12.sp,
                      color: blackPure,
                    ),
                  ),
                  Text(
                    'Nama: ' + transaction.user!.name!,
                    style: mediumRobotoFont.copyWith(
                      fontSize: 12.sp,
                      color: blackPure,
                    ),
                  ),
                  Text(
                    'ID User: ' + transaction.user!.id!,
                    style: mediumRobotoFont.copyWith(
                      fontSize: 12.sp,
                      color: blackPure,
                    ),
                  ),
                  Text(
                    'Petugas: ' + transaction.petugas!.name!,
                    style: mediumRobotoFont.copyWith(
                      fontSize: 12.sp,
                      color: blackPure,
                    ),
                  ),
                  Text(
                    'ID Petugas: ' + transaction.petugas!.id!,
                    style: mediumRobotoFont.copyWith(
                      fontSize: 12.sp,
                      color: blackPure,
                    ),
                  ),
                  const Divider(
                    color: blackPure,
                    thickness: 1,
                  ),
                  FutureBuilder<List<TransactionItem>>(
                      future: _futureTransactionItems(transaction.id!),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<TransactionItem>> snapshot) {
                        if (snapshot.hasData) {
                          List<TransactionItem> transactionItems =
                              snapshot.data!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: (95 * transactionItems.length).h,
                                child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      TransactionItem transactionItem =
                                          snapshot.data![index];

                                      return ListTile(
                                        leading: Text(
                                          transactionItem.qty.toString() +
                                              ' kg ',
                                          style: mediumRobotoFont.copyWith(
                                            fontSize: 10.sp,
                                            color: blackPure,
                                          ),
                                        ),
                                        title: Text(
                                          transactionItem.item!.name!,
                                          style: mediumRobotoFont.copyWith(
                                            fontSize: 10.sp,
                                            color: blackPure,
                                          ),
                                        ),
                                        trailing: Text(
                                          transactionItem.item!.sell.toString(),
                                          style: mediumRobotoFont.copyWith(
                                            fontSize: 10.sp,
                                            color: blackPure,
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              const Divider(
                                color: blackPure,
                                thickness: 1,
                              ),
                              Text('Total exp: ${transaction.total_exp}',
                                  style: mediumRobotoFont.copyWith(
                                    fontSize: 12.sp,
                                    color: blackPure,
                                  )),
                              Text(
                                  'Total balance: ${transaction.total_balance}',
                                  style: mediumRobotoFont.copyWith(
                                    fontSize: 12.sp,
                                    color: blackPure,
                                  )),
                            ],
                          );
                        }

                        return CircularProgressIndicator();
                      }),
                ],
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
