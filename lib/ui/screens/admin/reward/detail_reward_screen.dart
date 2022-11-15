import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trash_induc/ui/widgets/form_admin.dart';
import 'package:trash_induc/utils/const.dart';

import '../../../../models/reward.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/app_bar.dart';

class AdminDetailRewardScreen extends StatefulWidget {
  const AdminDetailRewardScreen({
    Key? key,
    required this.reward,
  }) : super(key: key);

  final Reward reward;

  @override
  _AdminDetailRewardScreenState createState() =>
      _AdminDetailRewardScreenState();
}

class _AdminDetailRewardScreenState extends State<AdminDetailRewardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Detail reward'),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 8.w,
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: widget.reward.photoUrl != ''
                    ? CircleAvatar(
                        radius: 100.r,
                        backgroundColor: darkGreen,
                        child: CircleAvatar(
                          radius: 90.r,
                          backgroundImage: CachedNetworkImageProvider(
                              widget.reward.photoUrl!),
                        ),
                      )
                    : SizedBox(
                        height: 200.h,
                        width: 60.w,
                        child: Center(
                          child: Text('Tidak ada foto'),
                        )),
              ),
              FormAdmin(
                label: 'Nama reward',
                initial: widget.reward.name,
                readOnly: true,
              ),
              FormAdmin(
                label: 'Harga reward',
                initial: widget.reward.cost.toString(),
                readOnly: true,
              ),
              FormAdmin(
                label: 'Berakhir pada',
                initial: dateFormat.format(widget.reward.expired_at!.toDate()),
                readOnly: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}
