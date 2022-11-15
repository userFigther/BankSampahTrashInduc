import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import '../../../../models/mission.dart';
import '../../../../repository/mission_repository.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/form_admin.dart';
import '../../../widgets/snackbar.dart';

class AdminEditMissionScreen extends StatefulWidget {
  const AdminEditMissionScreen({
    Key? key,
    required this.mission,
  }) : super(key: key);
  static String routeName = '/admin_edit_reward';

  final Mission mission;

  @override
  _AdminEditMissionScreenState createState() => _AdminEditMissionScreenState();
}

class _AdminEditMissionScreenState extends State<AdminEditMissionScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController expController = TextEditingController();
  TextEditingController balanceController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.mission.name!;
    expController.text = widget.mission.exp.toString();
    balanceController.text = widget.mission.balance.toString();
  }

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
          'Update misi',
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
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                builder: (context, value, child) {
                  final repository = Provider.of<MissionRepository>(context);
                  return ListTile(
                    title: Text(
                      'Sembunyikan dari misi',
                      style: boldRobotoFont.copyWith(
                        fontSize: 10.sp,
                        color: darkGray,
                      ),
                    ),
                    leading: Checkbox(
                      value: widget.mission.hidden,
                      onChanged: (bool) {
                        repository.setCheckBoxSembunyikan(bool!);
                      },
                    ),
                  );
                },
              ),
              Consumer(
                builder: (context, value, child) {
                  final repository = Provider.of<MissionRepository>(context);
                  return ListTile(
                    title: Text(
                      'Aktifkan misi',
                      style: boldRobotoFont.copyWith(
                        fontSize: 10.sp,
                        color: darkGray,
                      ),
                    ),
                    leading: Checkbox(
                      value: widget.mission.is_active,
                      onChanged: (bool) {
                        repository.setCheckBoxAktifkan(bool!);
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
              updateData();
            },
            child: Text(
              'Update misi',
              style: boldRobotoFont.copyWith(
                fontSize: 10.sp,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future updateData() async {
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
      await missionRef.doc(widget.mission.id).update({
        'name': name,
        'exp': int.parse(exp),
        'balance': int.parse(balance),
        'is_active': is_active,
        'hidden': hidden
      }).then((value) {
        CustomSnackbar.buildSnackbar(context, 'Berhasil mengubah misi', 1);
        Navigator.of(context).pop();
      });
    } catch (e) {
      CustomSnackbar.buildSnackbar(context, 'Gagal mengubah misi: $e', 0);
    }
  }
}
