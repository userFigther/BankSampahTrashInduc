import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import '../../../../repository/mission_repository.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/form_admin.dart';
import '../../../widgets/snackbar.dart';

class AdminAddMissionScreen extends StatefulWidget {
  const AdminAddMissionScreen({Key? key}) : super(key: key);
  static String routeName = '/admin_add_mission';

  @override
  _AdminAddMissionScreenState createState() => _AdminAddMissionScreenState();
}

class _AdminAddMissionScreenState extends State<AdminAddMissionScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController expController = TextEditingController();
  TextEditingController balanceController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    expController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreen,
        leading: IconButton(
            onPressed: () {
              final repository = Provider.of<MissionRepository>(
                context,
                listen: false,
              );
              Navigator.of(context).pop();
              repository.clearAll();
            },
            icon: Icon(
              Icons.arrow_back_ios,
            )),
        title: Text(
          'Tambah misi',
          style: boldRobotoFont.copyWith(
            fontSize: 14.sp,
          ),
        ),
        titleSpacing: 0,
        centerTitle: true,
      ),
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
                  FormAdmin(
                    label: 'Nama misi',
                    controller: nameController,
                    type: TextInputType.text,
                  ),
                  FormAdmin(
                    label: 'Exp yang didapat',
                    controller: expController,
                    type: TextInputType.number,
                  ),
                  FormAdmin(
                    label: 'Balance yang didapat',
                    controller: balanceController,
                    type: TextInputType.number,
                    action: TextInputAction.done,
                  ),
                  Consumer(
                    builder: (context, repository, child) {
                      final repository =
                          Provider.of<MissionRepository>(context);
                      return ListTile(
                        title: Text(
                          'Sembunyikan dari misi',
                          style: boldRobotoFont.copyWith(
                            fontSize: 10.sp,
                            color: darkGray,
                          ),
                        ),
                        leading: Checkbox(
                          value: repository.isSembunyikanChecked,
                          onChanged: (bool? value) {
                            repository.setCheckBoxSembunyikan(value!);
                          },
                        ),
                      );
                    },
                  ),
                  Consumer(
                    builder: (context, repository, child) {
                      final repository =
                          Provider.of<MissionRepository>(context);
                      return ListTile(
                        title: Text(
                          'Aktifkan misi',
                          style: boldRobotoFont.copyWith(
                            fontSize: 10.sp,
                            color: darkGray,
                          ),
                        ),
                        leading: Checkbox(
                          value: repository.isAktifkanChecked,
                          onChanged: (bool? value) {
                            repository.setCheckBoxAktifkan(value!);
                          },
                        ),
                      );
                    },
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
              submitData();
            },
            child: Text(
              'Tambahkan misi',
              style: boldRobotoFont.copyWith(
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future submitData() async {
    final repository = Provider.of<MissionRepository>(
      context,
      listen: false,
    );

    final missionRef = FirebaseFirestore.instance.collection('missions');

    String name = nameController.text;
    String exp = expController.text;
    String balance = balanceController.text;
    bool is_active = repository.isAktifkanChecked;
    bool hidden = repository.isSembunyikanChecked;

    try {
      await missionRef.add({
        'name': name,
        'exp': int.parse(exp),
        'balance': int.parse(balance),
        'is_active': is_active,
        'hidden': hidden
      }).then((value) {
        missionRef.doc(value.id).update({
          'id': value.id,
        }).then((value) {
          CustomSnackbar.buildSnackbar(context, 'Berhasil menambahkan misi', 1);
          Navigator.of(context).pop();
        });
      });
    } catch (e) {
      CustomSnackbar.buildSnackbar(context, 'Gagal menambahkan misi: $e', 0);
    }
  }
}
