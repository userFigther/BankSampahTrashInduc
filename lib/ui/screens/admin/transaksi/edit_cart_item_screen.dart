import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import '../../../../models/cart_item.dart';
import '../../../../models/item.dart';
import '../../../../repository/transaction_repository.dart';
import '../../../../shared/color.dart';
import '../../../widgets/app_bar.dart';

class EditCartItemFormScreen extends StatefulWidget {
  final CartItem cartItem;
  const EditCartItemFormScreen(
    this.cartItem, {
    Key? key,
  }) : super(key: key);

  @override
  _EditCartItemFormScreenState createState() => _EditCartItemFormScreenState();
}

class _EditCartItemFormScreenState extends State<EditCartItemFormScreen> {
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
    weightController.text = widget.cartItem.qty.toString();
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Update item'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 16.h,
          horizontal: 8.w,
        ),
        child: Form(
          child: Column(
            children: [
              FutureBuilder<List<Item>>(
                  future: fetchItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasData) {
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
                        value: snapshot.data!.firstWhere(
                            (Item i) => i.id == widget.cartItem.item.id),
                        items: snapshot.data!
                            .map((value) => DropdownMenuItem(
                                  child: Text(
                                    value.name.toString() +
                                        ' - ' +
                                        value.sell.toString() +
                                        '/kg',
                                  ),
                                  value: value,
                                ))
                            .toList(),
                      );
                    }

                    return snapshot.hasError
                        ? Text(snapshot.error.toString())
                        : Text('Gagal memuat data');
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: darkGreen,
                ),
                onPressed: () {
                  final repository = Provider.of<TransactionRepository>(
                    context,
                    listen: false,
                  );

                  var ci = widget.cartItem;
                  if (selectedItem != null) {
                    ci.item = selectedItem!;
                  }

                  double? weightVal = double.tryParse(
                      weightController.text.replaceAll(',', '.'));
                  if (weightVal != null && weightVal != ci.qty) {
                    ci.qty = weightVal.toDouble();
                  }

                  repository.updateItem(ci);
                  Navigator.of(context).pop();
                },
                child: Text('Update data'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
