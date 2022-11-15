import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trash_induc/ui/widgets/form_admin.dart';

import '../../../../models/item.dart';
import '../../../../shared/color.dart';
import '../../../../shared/font.dart';
import '../../../widgets/app_bar.dart';

class AdminDetailItemScreen extends StatefulWidget {
  const AdminDetailItemScreen({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item item;

  @override
  _AdminDetailItemScreenState createState() => _AdminDetailItemScreenState();
}

class _AdminDetailItemScreenState extends State<AdminDetailItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Detail sampah"),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: CircleAvatar(
                  backgroundColor: darkGreen,
                  radius: 100.r,
                  child: CircleAvatar(
                    backgroundColor: widget.item.photoUrl == ''
                        ? grayPure
                        : Colors.transparent,
                    radius: 90.r,
                    backgroundImage: widget.item.photoUrl == ""
                        ? Image.asset("assets/images/placeholder-image.png")
                            .image
                        : CachedNetworkImageProvider(widget.item.photoUrl!),
                  ),
                ),
              ),
              FormAdmin(
                label: 'Nama item',
                initial: widget.item.name,
                readOnly: true,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormAdmin(
                          label: 'Harga jual',
                          initial: widget.item.sell.toString(),
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormAdmin(
                          label: 'Harga beli',
                          initial: widget.item.buy.toString(),
                          readOnly: true,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormAdmin(
                          label: 'Exp poin/kg',
                          initial: widget.item.exp_point.toString(),
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormAdmin(
                          label: 'Balance poin/kg',
                          initial: widget.item.balance_point.toString(),
                          readOnly: true,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
