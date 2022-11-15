import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';

import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/form_admin.dart';
import '../../../widgets/snackbar.dart';

class AdminAddItemScreen extends StatefulWidget {
  const AdminAddItemScreen({Key? key}) : super(key: key);
  static String routeName = "/admin_add_trash";

  @override
  _AdminAddItemScreenState createState() => _AdminAddItemScreenState();
}

class _AdminAddItemScreenState extends State<AdminAddItemScreen> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController sellController = TextEditingController();
  TextEditingController buyController = TextEditingController();
  TextEditingController expController = TextEditingController();
  TextEditingController balanceController = TextEditingController();
  File? selectedFile;

  @override
  void dispose() {
    nameController.dispose();
    sellController.dispose();
    buyController.dispose();
    expController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Tambah sampah"),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 8.w,
        ),
        children: [
          Form(
            key: key,
            child: Column(
              children: [
                Center(
                    child: Stack(children: [
                  CircleAvatar(
                    radius: 100.r,
                    backgroundColor: darkGreen,
                    child: CircleAvatar(
                      backgroundColor:
                          selectedFile == null ? grayPure : Colors.transparent,
                      backgroundImage: selectedFile == null
                          ? Image.asset("assets/images/placeholder-image.png")
                              .image
                          : Image.file(selectedFile!).image,
                      radius: 90.r,
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: darkGreen,
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    height: 80.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                              15.r,
                                            ),
                                            topRight: Radius.circular(
                                              15.r,
                                            ))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton.icon(
                                            onPressed: () async {
                                              await pickImage(
                                                ImageSource.gallery,
                                                context,
                                              );

                                              Navigator.of(context).pop();
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                            ),
                                            label: Text("Ganti foto")),
                                        TextButton.icon(
                                            onPressed: selectedFile == null
                                                ? null
                                                : () {
                                                    setState(() {
                                                      selectedFile = null;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                            icon: Icon(
                                              Icons.delete,
                                            ),
                                            label: Text("Hapus foto"))
                                      ],
                                    ),
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: whitePure,
                          ),
                        ),
                      ))
                ])),
                FormAdmin(
                  label: "Nama item",
                  controller: nameController,
                  type: TextInputType.text,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: FormAdmin(
                        label: "Harga jual(Rp)",
                        controller: sellController,
                        type: TextInputType.number,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: FormAdmin(
                        label: "Harga beli(Rp)",
                        controller: buyController,
                        type: TextInputType.number,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: FormAdmin(
                        controller: expController,
                        label: "Exp point/kg",
                        type: TextInputType.number,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: FormAdmin(
                        label: "Balance point/kg",
                        controller: balanceController,
                        type: TextInputType.number,
                        action: TextInputAction.done,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 5,
                primary: darkGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                  8.r,
                ))),
            onPressed: () {
              submitData(
                "items",
                selectedFile,
                context,
              );
            },
            child: Text(
              "Tambahkan item",
              style: boldRobotoFont.copyWith(
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future pickImage(ImageSource source, BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      setState(() {
        selectedFile = File(image.path).absolute;
      });
    } on Exception catch (e) {
      print("Failed to take image: $e");
    }
  }

  Future submitData(
      String destination, File? pickedFile, BuildContext context) async {
    String url = '';
    String itemName = nameController.text;
    int itemBuy = int.parse(buyController.text);
    int itemSell = int.parse(sellController.text);
    int itemExp = int.parse(expController.text);
    int itemBalance = int.parse(balanceController.text);
    final itemRef = FirebaseFirestore.instance.collection(destination);

    try {
      if (pickedFile != null) {
        String fileName = basename(pickedFile.path);

        final storageRef =
            FirebaseStorage.instance.ref(destination).child(fileName);
        await storageRef.putFile(pickedFile);
        url = await storageRef.getDownloadURL();
      }
      await itemRef.add({
        "name": itemName,
        "sell": itemSell,
        "buy": itemBuy,
        "exp_point": itemExp,
        "balance_point": itemBalance,
        "photoUrl": url,
      }).then((value) {
        CustomSnackbar.buildSnackbar(context, "Berhasil menambahkan sampah", 1);
        Navigator.of(context).pop();
      });
    } catch (e) {
      CustomSnackbar.buildSnackbar(
          context, "Gagal menambahkan sampah karena: $e", 0);
    }
  }
}
