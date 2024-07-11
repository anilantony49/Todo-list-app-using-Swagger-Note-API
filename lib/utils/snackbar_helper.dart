import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
      content: Text(
    message,
    style: const TextStyle(color: Colors.red),
  ));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  void showSuccsessMessage(BuildContext context, {required String message}) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



