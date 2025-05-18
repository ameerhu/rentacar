import 'package:flutter/material.dart';

showErrorMessage(BuildContext context, dynamic err) {
  showSnackBar(context, err.toString(), Colors.red);
}

showInfoMessage(BuildContext context, dynamic err) {
  showSnackBar(context, err, Colors.green);
}

void showSnackBar(BuildContext context, String msg, Color color) {
  var snackBar = SnackBar(
    content: Text(msg),
    backgroundColor: color,
    duration: const Duration(seconds: 5),
    action: SnackBarAction(
      label: "close",
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
