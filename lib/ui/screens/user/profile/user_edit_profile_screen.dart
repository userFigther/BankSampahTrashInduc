import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/snackbar.dart';
import '../../../widgets/text_form_field.dart';
import '../../../../models/user.dart' as UserModel;

class UserEditProfileScreen extends StatefulWidget {
  static String routeName = "/edit_profile";

  UserEditProfileScreen({
    Key? key,
    required this.user,
    required this.copyOfUrl,
  }) : super(key: key);

  final UserModel.User user;
  String copyOfUrl;

  @override
  _UserEditProfileScreenState createState() => _UserEditProfileScreenState();
}

class _UserEditProfileScreenState extends State<UserEditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postalController = TextEditingController();

  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool deletePhoto = false;
  File? selectedFile;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.name!;
    phoneController.text = widget.user.phone!;
    addressController.text = widget.user.address!;
    postalController.text = widget.user.postalCode!;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    postalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: darkGreen,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: whitePure,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                label: Text(
                  "Profil",
                  style: regularRobotoFont.copyWith(
                    fontSize: 14.sp,
                    color: whitePure,
                  ),
                ),
              ),
              SizedBox(
                width: 60.w,
              ),
              Center(
                child: Text(
                  "Edit Profil",
                  style: boldRobotoFont.copyWith(
                    fontSize: 18.sp,
                    color: whitePure,
                  ),
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Form(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: ListView(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: Stack(children: [
                      CircleAvatar(
                        radius: 51.r,
                        backgroundColor: lightYellow,
                        child: CircleAvatar(
                          backgroundImage: widget.copyOfUrl == ""
                              ? selectedFile == null
                                  ? Image.asset("assets/images/photo.png").image
                                  : Image.file(selectedFile!).image
                              : Image.network(widget.copyOfUrl).image,
                          radius: 45.r,
                        ),
                      ),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            backgroundColor: yellowPure,
                            child: IconButton(
                                color: whitePure,
                                onPressed: () {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                12.r,
                                              ),
                                              topRight: Radius.circular(
                                                12.r,
                                              ))),
                                      elevation: 5,
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          height: 40.h,
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
                                                    ).then(
                                                        (value) => setState(() {
                                                              deletePhoto =
                                                                  false;
                                                            }));

                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: Icon(
                                                    Icons.edit,
                                                  ),
                                                  label: Text("Ganti foto")),
                                              TextButton.icon(
                                                  onPressed: (widget
                                                                  .copyOfUrl ==
                                                              "" &&
                                                          selectedFile == null)
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            deletePhoto = true;
                                                            selectedFile = null;
                                                            widget.copyOfUrl =
                                                                "";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
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
                                )),
                          ))
                    ]),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomTextForm(
                    initial: widget.user.id,
                    label: "User ID",
                    keyboardType: TextInputType.none,
                    readOnly: true,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextForm(
                    controller: nameController,
                    label: "Nama Lengkap",
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Nama tidak boleh kosong";
                      }
                      if (value.length < 2) {
                        return "Nama harus lebih dari 1 karakter";
                      }

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextForm(
                    label: "Nomor HP",
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    validator: (value) {
                      if (value!.isEmpty || value == null || value == "-") {
                        return "Nomor HP tidak boleh kosong";
                      }
                      if (value.length > 13 || value.length < 8) {
                        return "Nomor HP tidak valid";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextForm(
                    label: "Alamat lengkap",
                    keyboardType: TextInputType.multiline,
                    controller: addressController,
                    validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return "Alamat tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextForm(
                    label: "Kode Pos",
                    keyboardType: TextInputType.number,
                    controller: postalController,
                    validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return "Kode pos tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      submitData(
                        "users",
                        selectedFile!,
                        context,
                      );
                    },
                    child: Text("Update profil"),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future pickImage(ImageSource source) async {
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
    String? url;
    String name = nameController.text;
    String phoneNumber = phoneController.text;
    String address = addressController.text;
    String postalCode = postalController.text;
    var storageRef = FirebaseStorage.instance;
    var userRef = FirebaseFirestore.instance.collection(destination);

    try {
      if (deletePhoto) {
        try {
          await storageRef.refFromURL(widget.user.photoUrl!).delete();
          url = "";
        } catch (e) {
          print(e);
        }
      }

      if (pickedFile != null) {
        String fileName = basename(pickedFile.path);
        if (widget.user.photoUrl == "") {
          await storageRef.ref(destination).child(fileName).putFile(pickedFile);
          url = await storageRef
              .ref(destination)
              .child(fileName)
              .getDownloadURL();
        } else {
          try {
            await storageRef.refFromURL(widget.user.photoUrl!).delete();
            await storageRef
                .ref(destination)
                .child(fileName)
                .putFile(pickedFile);
            url = await storageRef
                .ref(destination)
                .child(fileName)
                .getDownloadURL();
          } catch (e) {
            print(e);
          }
        }
      }

      await userRef.doc(widget.user.id).update({
        "name": name,
        "phoneNumber": phoneNumber,
        "address": address,
        "postalCode": postalCode,
        "photoUrl": url
      }).then((value) {
        CustomSnackbar.buildSnackbar(context, "Berhasil mengupdate profil", 1);
        Navigator.of(context).pop();
      });
    } catch (e) {
      CustomSnackbar.buildSnackbar(context, "Gagal mengupdate profil: $e", 0);
    }
  }
}
