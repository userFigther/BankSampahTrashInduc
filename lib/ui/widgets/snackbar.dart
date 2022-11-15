import 'package:flutter/material.dart';

import '../../shared/color.dart';

class CustomSnackbar {
  static buildSnackbar(BuildContext context, String message, int code) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: code == 0 ? redDanger : Colors.green,
      duration: Duration(
        seconds: 2,
      ),
      action: SnackBarAction(
        textColor: whitePure,
        label: "Dismiss",
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }
}
