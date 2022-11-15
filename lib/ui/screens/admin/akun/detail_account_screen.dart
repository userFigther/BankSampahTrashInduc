import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../models/user.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/form_admin.dart';

class AdminDetailAccountScreen extends StatefulWidget {
  const AdminDetailAccountScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _AdminDetailAccountScreenState createState() =>
      _AdminDetailAccountScreenState();
}

class _AdminDetailAccountScreenState extends State<AdminDetailAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreen,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
            )),
        title: Text(
          'Detail Akun',
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
          CircleAvatar(
            radius: 110.r,
            backgroundColor: lightGreen,
            child: CircleAvatar(
              radius: 105.r,
              backgroundImage: widget.user.photoUrl == ''
                  ? Image.asset('assets/images/photo.png').image
                  : CachedNetworkImageProvider(widget.user.photoUrl!),
            ),
          ),
          FormAdmin(
            label: 'Nama',
            initial: widget.user.name,
            readOnly: true,
          ),
          FormAdmin(
            label: 'Email',
            initial: widget.user.email,
            readOnly: true,
          ),
          FormAdmin(
            label: 'Phone',
            initial:
                widget.user.phone == '' ? 'Belum diisi' : widget.user.phone,
            readOnly: true,
          ),
          FormAdmin(
            label: 'Balance',
            initial: widget.user.balance.toString(),
            readOnly: true,
          ),
          FormAdmin(
            label: 'Exp',
            initial: widget.user.exp.toString(),
            readOnly: true,
          ),
          FormAdmin(
            label: 'Membership',
            initial: widget.user.membership,
            readOnly: true,
          ),
          FormAdmin(
            label: 'Role',
            initial: widget.user.role,
            readOnly: true,
          ),
        ],
      ),
    );
  }
}
