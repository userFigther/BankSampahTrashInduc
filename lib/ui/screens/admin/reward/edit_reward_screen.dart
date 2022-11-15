import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:path/path.dart';

import '../../../../models/reward.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../../utils/const.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/snackbar.dart';

class AdminEditRewardScreen extends StatefulWidget {
  AdminEditRewardScreen({
    Key? key,
    required this.reward,
    required this.copyOfUrl,
  }) : super(key: key);
  static String routeName = '/admin_edit_reward';

  final Reward reward;
  String copyOfUrl;

  @override
  _AdminEditRewardScreenState createState() => _AdminEditRewardScreenState();
}

class _AdminEditRewardScreenState extends State<AdminEditRewardScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  DateTime? selectedDate;
  File? selectedFile;
  bool deletePhoto = false;

  @override
  void dispose() {
    nameController.dispose();
    costController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedDate = widget.reward.expired_at!.toDate();
    nameController.text = widget.reward.name!;
    costController.text = widget.reward.cost.toString();
    dateController.text =
        DateFormat('dd/MM/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(
      widget.reward.expired_at!.microsecondsSinceEpoch,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit reward'),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 8.w,
        ),
        children: [
          Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Stack(children: [
                    CircleAvatar(
                      radius: 100.r,
                      backgroundColor: darkGreen,
                      child: CircleAvatar(
                        backgroundColor:
                            widget.copyOfUrl == '' ? grayPure : darkGreen,
                        backgroundImage: widget.copyOfUrl == ''
                            ? selectedFile == null
                                ? Image.asset(
                                        'assets/images/placeholder-image.png')
                                    .image
                                : Image.file(selectedFile!).image
                            : CachedNetworkImageProvider(widget.copyOfUrl),
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
                                                ).then((value) => setState(() {
                                                      deletePhoto = false;
                                                    }));

                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                              ),
                                              label: Text('Ganti foto')),
                                          TextButton.icon(
                                              onPressed: (widget.copyOfUrl ==
                                                          '' &&
                                                      selectedFile == null)
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        deletePhoto = true;
                                                        selectedFile = null;
                                                        widget.copyOfUrl = '';
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                              icon: Icon(
                                                Icons.delete,
                                              ),
                                              label: Text('Hapus foto'))
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
                  Text(
                    'Nama reward',
                    style: boldRobotoFont.copyWith(
                      fontSize: 14.sp,
                      color: darkGray,
                    ),
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                        8.r,
                      )),
                      isDense: true,
                    ),
                  ),
                  Text(
                    'Harga reward',
                    style: boldRobotoFont.copyWith(
                      fontSize: 14.sp,
                      color: darkGray,
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: costController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: 2000',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                        8.r,
                      )),
                      isDense: true,
                    ),
                  ),
                  Text(
                    'Berakhir pada tanggal',
                    style: boldRobotoFont.copyWith(
                      fontSize: 14.sp,
                      color: darkGray,
                    ),
                  ),
                  TextFormField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: widget.reward.expired_at!.toDate(),
                              firstDate: now,
                              lastDate: DateTime(2050))
                          .then((value) {
                        setState(() {
                          selectedDate = value;
                          dateController.text = dateFormat.format(
                            value!,
                          );
                        });
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                        8.r,
                      )),
                      isDense: true,
                    ),
                  ),
                ],
              )),
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
                'rewards',
                selectedFile,
                context,
              );
            },
            child: Text(
              'Update reward',
              style: boldRobotoFont.copyWith(
                fontSize: 14.sp,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      setState(() {
        selectedFile = File(image.path).absolute;
      });
    } on Exception catch (e) {
      print('Failed to take image: $e');
    }
  }

  Future submitData(
      String destination, File? pickedFile, BuildContext context) async {
    String url = widget.reward.photoUrl!;
    String rewardName = nameController.text;
    int rewardCost = int.parse(costController.text);
    DateTime rewardExpired = selectedDate!;
    var rewardRef = FirebaseFirestore.instance.collection(destination);
    var storageRef = FirebaseStorage.instance;

    try {
      if (deletePhoto) {
        await storageRef.refFromURL(widget.reward.photoUrl!).delete();
        url = '';
      }

      if (pickedFile != null) {
        String fileName = basename(pickedFile.path);

        if (widget.reward.photoUrl == '') {
          await storageRef.ref(destination).child(fileName).putFile(pickedFile);
          url = await storageRef
              .ref(destination)
              .child(fileName)
              .getDownloadURL();
        } else {
          await storageRef.refFromURL(widget.reward.photoUrl!).delete();
          await storageRef.ref(destination).child(fileName).putFile(pickedFile);
          url = await storageRef
              .ref(destination)
              .child(fileName)
              .getDownloadURL();
        }
      }

      await rewardRef.doc(widget.reward.id).update({
        'name': rewardName,
        'cost': rewardCost,
        'photoUrl': url,
        'expired_at': rewardExpired,
      }).then((value) {
        CustomSnackbar.buildSnackbar(context, 'Berhasil mengedit reward', 1);
        Navigator.of(context).pop();
      });
    } catch (e) {
      CustomSnackbar.buildSnackbar(context, 'Gagal mengedit reward: $e', 0);
    }
  }
}
