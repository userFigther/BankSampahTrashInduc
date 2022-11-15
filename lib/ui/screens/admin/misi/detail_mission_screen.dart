import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trash_induc/ui/widgets/form_admin.dart';

import '../../../../models/mission.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/app_bar.dart';

class AdminDetailMissionScreen extends StatefulWidget {
  const AdminDetailMissionScreen({
    Key? key,
    required this.mission,
  }) : super(key: key);

  final Mission mission;

  @override
  AdminDetailMissionScreenState createState() =>
      AdminDetailMissionScreenState();
}

class AdminDetailMissionScreenState extends State<AdminDetailMissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Detail misi'),
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
                initial: widget.mission.name,
                readOnly: true,
              ),
              FormAdmin(
                label: 'Exp poin',
                initial: widget.mission.exp.toString(),
                readOnly: true,
              ),
              FormAdmin(
                label: 'Balance poin',
                initial: widget.mission.balance.toString(),
                readOnly: true,
              ),
              ListTile(
                title: Text(
                  'Sembunyikan dari misi',
                  style: boldRobotoFont.copyWith(
                    fontSize: 10.sp,
                    color: darkGray,
                  ),
                ),
                leading: Checkbox(
                  value: widget.mission.hidden,
                  onChanged: null,
                ),
              ),
              ListTile(
                title: Text(
                  'Aktifkan misi',
                  style: boldRobotoFont.copyWith(
                    fontSize: 10.sp,
                    color: darkGray,
                  ),
                ),
                leading: Checkbox(
                  value: widget.mission.is_active,
                  onChanged: null,
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
