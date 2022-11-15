import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trash_induc/ui/screens/admin/transaksi/add_transaction_screen.dart';
import 'package:trash_induc/ui/screens/admin/transaksi/detail_transaction_screen.dart';
import 'package:trash_induc/utils/const.dart';

import '../../../../models/transaction.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/admin_drawer.dart';

class AdminIndexTransactionScreen extends StatefulWidget {
  const AdminIndexTransactionScreen({Key? key}) : super(key: key);
  static String routeName = '/officer_index_transaction';

  @override
  _AdminIndexTransactionScreenState createState() =>
      _AdminIndexTransactionScreenState();
}

class _AdminIndexTransactionScreenState
    extends State<AdminIndexTransactionScreen> {
  TextEditingController searchController = TextEditingController();
  int dropdownValue = 10;
  List<int> dropdownValues = [
    10,
    25,
    50,
  ];

  Future<List<Transaction>>? _futureTransactions;

  CollectionReference transactionRef =
      FirebaseFirestore.instance.collection('transactions');

  Future<List<Transaction>> _filterTransactions() async {
    var transactions = <Transaction>[];

    if (searchController.text.trim() != '') {
      var searchQuery = searchController.text.trim();
      var userEmail = await FirebaseFirestore.instance
          .collection('transactions')
          .where('user.email', isGreaterThanOrEqualTo: searchQuery)
          .where('user.email', isLessThan: searchQuery + 'z')
          .get();

      var userName = await FirebaseFirestore.instance
          .collection('transactions')
          .where('user.name', isGreaterThan: searchQuery)
          .where('user.name', isLessThan: searchQuery + 'z')
          .get();

      var petugasEmail = await FirebaseFirestore.instance
          .collection('transactions')
          .where('petugas.email', isGreaterThanOrEqualTo: searchQuery)
          .where('petugas.email', isLessThan: searchQuery + 'z')
          .get();

      var petugasName = await FirebaseFirestore.instance
          .collection('transactions')
          .where('petugas.name', isGreaterThan: searchQuery)
          .where('petugas.name', isLessThan: searchQuery + 'z')
          .get();

      var data = [];
      data.addAll(userEmail.docs);
      data.addAll(userName.docs);
      data.addAll(petugasEmail.docs);
      data.addAll(petugasName.docs);
      transactions.addAll(
        data.map((e) => Transaction.fromJson(e.data(), id: e.id)).toList(),
      );
    } else {
      var result =
          await FirebaseFirestore.instance.collection('transactions').get();
      transactions = result.docs
          .map((e) => Transaction.fromJson(e.data(), id: e.id))
          .toList();
    }

    return transactions;
  }

  Future<void> refresh() async {
    setState(() {
      _futureTransactions = _filterTransactions();
    });
  }

  @override
  void initState() {
    super.initState();
    _futureTransactions = _filterTransactions();
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
          'Transaksi',
          style: boldRobotoFont.copyWith(
            fontSize: 14.sp,
          ),
        ),
        titleSpacing: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdminAddTransactionScreen(),
                ),
              );
            },
            icon: Image.asset('assets/images/buttonCreate.png'),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => refresh(),
        child: ListView(
          children: [
            FutureBuilder<List<Transaction>>(
                future: _futureTransactions,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return PaginatedDataTable(
                      rowsPerPage: dropdownValue,
                      columns: [
                        DataColumn(
                          label: Text('No'),
                          numeric: true,
                        ),
                        DataColumn(
                          label: Text('User'),
                        ),
                        DataColumn(
                          label: Text('Petugas'),
                        ),
                        DataColumn(
                          label: Text('Tanggal'),
                        ),
                      ],
                      source: AdminDataTransaction(
                          data: snapshot.data!, context: context),
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
                                  _futureTransactions = _filterTransactions();
                                });
                              },
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                    8.r,
                                  )),
                                  hintText: 'Cari transaksi',
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
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: lightGreen,
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class AdminDataTransaction extends DataTableSource {
  final List<Transaction> data;
  final BuildContext context;

  AdminDataTransaction({
    required this.data,
    required this.context,
  });

  detailPage(Transaction transaction) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DetailTransactionScreen(
        transaction: transaction,
      ),
    ));
  }

  @override
  DataRow? getRow(int index) {
    Transaction transaction = data[index];
    return DataRow(cells: [
      DataCell(
        Text(
          (index + 1).toString(),
        ),
        onTap: () => detailPage(transaction),
      ),
      DataCell(
        Text(
          transaction.user!.name.toString(),
        ),
        onTap: () => detailPage(transaction),
      ),
      DataCell(
        Text(
          transaction.petugas!.name.toString(),
        ),
        onTap: () => detailPage(transaction),
      ),
      DataCell(
        Text(dateFormat.format(transaction.created_at!.toDate())),
        onTap: () => detailPage(transaction),
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
