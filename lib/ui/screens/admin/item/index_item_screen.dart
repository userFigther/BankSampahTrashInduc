import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trash_induc/ui/screens/admin/item/add_item_screen.dart';
import 'package:trash_induc/ui/screens/admin/item/detail_item_screen.dart';
import 'package:trash_induc/ui/screens/admin/item/edit_item_screen.dart';

import '../../../../models/item.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/admin_drawer.dart';
import '../../../widgets/snackbar.dart';

class AdminIndexItemScreen extends StatefulWidget {
  AdminIndexItemScreen({Key? key}) : super(key: key);
  static String routeName = '/admin_index_trash';

  @override
  _AdminIndexItemScreenState createState() => _AdminIndexItemScreenState();
}

class _AdminIndexItemScreenState extends State<AdminIndexItemScreen> {
  int dropdownValue = 10;
  TextEditingController searchController = TextEditingController();
  List<int> dropdownValues = [
    10,
    25,
    50,
  ];

  Future<List<Item>>? _futureItems;

  Future<List<Item>> _filterItems() async {
    var items = <Item>[];

    if (searchController.text.trim() != '') {
      var searchQuery = searchController.text.trim();
      var itemName = await FirebaseFirestore.instance
          .collection('items')
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThan: searchQuery + 'z')
          .get();

      var data = [];
      data.addAll(itemName.docs);
      items.addAll(
        data.map((e) => Item.fromJson(e.data(), id: e.id)).toList(),
      );
    } else {
      var result = await FirebaseFirestore.instance.collection('items').get();
      items =
          result.docs.map((e) => Item.fromJson(e.data(), id: e.id)).toList();
    }

    return items;
  }

  void refresh() {
    setState(() {
      _futureItems = _filterItems();
    });
  }

  @override
  void initState() {
    super.initState();
    _futureItems = _filterItems();
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
          'Sampah',
          style: boldRobotoFont.copyWith(
            fontSize: 14.sp,
          ),
        ),
        titleSpacing: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdminAddItemScreen(),
                ),
              );
              refresh();
            },
            icon: Image.asset('assets/images/buttonCreate.png'),
          )
        ],
      ),
      body: ListView(children: [
        FutureBuilder<List<Item>>(
          future: _futureItems,
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
                            _futureItems = _filterItems();
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                              8.r,
                            )),
                            hintText: 'Cari sampah',
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
                  ),
                  DataColumn(
                    label: Text('Nama'),
                  ),
                  DataColumn(
                    label: Text('Jual(/kg)'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Beli(/kg)'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Exp'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Balance'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Aksi'),
                  ),
                ],
                source: AdminDataItem(
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

class AdminDataItem extends DataTableSource {
  final _AdminIndexItemScreenState parent;
  final List<Item> data;
  final BuildContext context;

  AdminDataItem({
    required this.parent,
    required this.data,
    required this.context,
  });

  detailPage(Item item) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AdminDetailItemScreen(
        item: item,
      ),
    ));
  }

  deleteItem(String url, Item item) async {
    final storageRef = FirebaseStorage.instance;
    final itemRef = FirebaseFirestore.instance.collection('items');
    try {
      if (item.photoUrl != '') {
        await storageRef.refFromURL(url).delete();
      }
      await itemRef.doc(item.id).delete();
      parent.refresh();
      Navigator.pop(context);
      CustomSnackbar.buildSnackbar(
          context, 'Berhasil menghapus sampah: ${item.name}', 1);
    } catch (e) {
      CustomSnackbar.buildSnackbar(context, 'Gagal menghapus sampah: $e', 0);
    }
  }

  @override
  DataRow? getRow(int index) {
    Item item = data[index];
    return DataRow(cells: [
      DataCell(
        Text((index + 1).toString()),
        onTap: () => detailPage(item),
      ),
      DataCell(
        Text(
          item.name!,
        ),
        onTap: () => detailPage(item),
      ),
      DataCell(
        Text(
          item.sell.toString(),
        ),
        onTap: () => detailPage(item),
      ),
      DataCell(
        Text(
          item.buy.toString(),
        ),
        onTap: () => detailPage(item),
      ),
      DataCell(
        Text(
          item.exp_point.toString(),
        ),
        onTap: () => detailPage(item),
      ),
      DataCell(
        Text(
          item.balance_point.toString(),
        ),
        onTap: () => detailPage(item),
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
                    builder: (context) => AdminEditItemScreen(
                      item: item,
                      copyOfUrl: item.photoUrl!,
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
                                    text: item.name,
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
                                  parent.refresh();
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
                                  deleteItem(
                                    item.photoUrl!,
                                    item,
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
