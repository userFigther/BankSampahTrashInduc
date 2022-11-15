import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import '../../../../models/cart_item.dart';
import '../../../../models/item.dart';
import '../../../../repository/transaction_repository.dart';
import '../../../../shared/color.dart';
import '../../../widgets/app_bar.dart';

class CartItemFormScreen extends StatefulWidget {
  const CartItemFormScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CartItemFormScreenState createState() => _CartItemFormScreenState();
}

class _CartItemFormScreenState extends State<CartItemFormScreen> {
  TextEditingController weightController = TextEditingController();
  Item? selectedItem;
  Future<List<Item>>? fetchItems;

  Future<List<Item>> _fetchItems() async {
    var items = await FirebaseFirestore.instance.collection('items').get();
    return items.docs.map((i) => Item.fromJson(i.data(), id: i.id)).toList();
  }

  @override
  void initState() {
    fetchItems = _fetchItems();
    super.initState();
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Tambah item'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 8.w,
        ),
        child: Form(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder<List<Item>>(
                  future: fetchItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    return DropdownButtonFormField<Item>(
                      onChanged: (newValue) {
                        if (newValue == null) {
                          return;
                        }

                        setState(() {
                          selectedItem = newValue;
                        });
                      },
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      decoration: InputDecoration(
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                5.r,
                              ),
                              borderSide: BorderSide(
                                width: 2,
                                color: grayPure,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                5.r,
                              ),
                              borderSide: BorderSide(
                                width: 2,
                                color: lightGreen,
                              ))),
                      hint: Text(
                        'Jenis sampah',
                      ),
                      items: snapshot.hasData
                          ? snapshot.data!
                              .map((value) => DropdownMenuItem(
                                    child: Text(
                                      value.name.toString() +
                                          ' - ' +
                                          value.sell.toString() +
                                          '/kg',
                                    ),
                                    value: value,
                                  ))
                              .toList()
                          : [],
                    );
                  }),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Berat:',
              ),
              TextFormField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan berat sampah(kg)',
                ),
              ),
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: darkGreen,
                  ),
                  onPressed: () {
                    final repository = Provider.of<TransactionRepository>(
                      context,
                      listen: false,
                    );
                    repository.addItem(
                      CartItem(
                        selectedItem!,
                        selectedItem!.name!,
                        double.tryParse(
                                weightController.text.replaceAll(',', '.'))!
                            .toDouble(),
                        selectedItem!.sell!.toDouble(),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text('Tambahkan data'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
