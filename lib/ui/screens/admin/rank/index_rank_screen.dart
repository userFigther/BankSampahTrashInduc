import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/user.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/admin_drawer.dart';

class AdminIndexRankScreen extends StatefulWidget {
  const AdminIndexRankScreen({Key? key}) : super(key: key);
  static String routeName = '/admin_index_rank';

  @override
  _AdminIndexRankScreenState createState() => _AdminIndexRankScreenState();
}

class _AdminIndexRankScreenState extends State<AdminIndexRankScreen> {
  int dropdownValue = 10;
  List<int> dropdownValues = [
    10,
    25,
    50,
  ];
  TextEditingController searchController = TextEditingController();

  Future<List<User>>? _futureUsers;

  Future<List<User>> _filterUsers() async {
    var users = <User>[];

    if (searchController.text.trim() != '') {
      var searchQuery = searchController.text.trim().toLowerCase();
      var userName = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThan: searchQuery + 'z')
          .get();

      var data = [];
      data.addAll(userName.docs);
      users.addAll(
        data.map((e) => User.fromJson(e.data())).toList(),
      );
    } else {
      var result = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('balance', descending: true)
          .get();
      users = result.docs.map((e) => User.fromJson(e.data())).toList();
    }

    return users;
  }

  @override
  void initState() {
    super.initState();
    _futureUsers = _filterUsers();
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
          'Rank',
          style: boldRobotoFont.copyWith(
            fontSize: 14.sp,
          ),
        ),
        titleSpacing: 0,
        centerTitle: true,
      ),
      body: ListView(children: [
        FutureBuilder<List<User>>(
          future: _futureUsers,
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
                            _futureUsers = _filterUsers();
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                              8.r,
                            )),
                            hintText: 'Cari user',
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
                    label: Text('Rank'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Nama'),
                  ),
                  DataColumn(
                    label: Text('Membership'),
                  ),
                  DataColumn(
                    label: Text('EXP'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Balance'),
                    numeric: true,
                  ),
                ],
                source: AdminDataRank(
                  context: context,
                  data: snapshot.data!,
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ]),
    );
  }
}

class AdminDataRank extends DataTableSource {
  final List<User> data;
  final BuildContext context;

  AdminDataRank({
    required this.context,
    required this.data,
  });

  @override
  DataRow? getRow(int index) {
    User user = data[index];
    return DataRow(cells: [
      DataCell(
        Text((index + 1).toString()),
      ),
      DataCell(
        Text(user.name!),
      ),
      DataCell(
        Text(user.membership),
      ),
      DataCell(
        Text(
          user.exp!.toString(),
        ),
      ),
      DataCell(
        Text(
          user.balance!.toString(),
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
