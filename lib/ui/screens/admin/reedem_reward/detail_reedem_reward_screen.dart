import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trash_induc/utils/const.dart';

import '../../../../models/reedemed_reward.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/form_admin.dart';

class AdminDetailRedeemRewardScreen extends StatefulWidget {
  AdminDetailRedeemRewardScreen({
    Key? key,
    required this.redeemedReward,
  }) : super(key: key);

  RedeemedReward redeemedReward;

  @override
  _AdminDetailRedeemRewardScreenState createState() =>
      _AdminDetailRedeemRewardScreenState();
}

class _AdminDetailRedeemRewardScreenState
    extends State<AdminDetailRedeemRewardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Detail redeem'),
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
                child: widget.redeemedReward.reward!.photoUrl != ''
                    ? CircleAvatar(
                        radius: 100.r,
                        backgroundColor: darkGreen,
                        child: CircleAvatar(
                          radius: 90.r,
                          backgroundImage: CachedNetworkImageProvider(
                              widget.redeemedReward.reward!.photoUrl!),
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
                label: 'Nama reward yang di redeem',
                initial: widget.redeemedReward.reward!.name,
                readOnly: true,
              ),
              FormAdmin(
                label: 'Nama user',
                initial: widget.redeemedReward.user!.name,
                readOnly: true,
              ),
              FormAdmin(
                label: 'Nama petugas yang menangani',
                initial: widget.redeemedReward.petugas!.name == ''
                    ? 'Belum ditangani petugas'
                    : widget.redeemedReward.petugas!.name,
                readOnly: true,
              ),
              FormAdmin(
                label: 'Status',
                initial: widget.redeemedReward.status == 'pending'
                    ? 'Belum diproses'
                    : 'Selesai',
              ),
              FormAdmin(
                label: 'Diajukan pada tanggal',
                initial: dateFormat
                    .format(widget.redeemedReward.created_at!.toDate()),
                readOnly: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}
