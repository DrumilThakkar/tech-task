import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void mylog(String message) {
  if (kDebugMode) {
    log("TESTING : " + message);
  }

  //FOR LOG IN PRODUCTION MODE
  // if (!kDebugMode) {
  //   print("AJ: " + message);
  // }
}

void myPrint(message) {
  if (kDebugMode) {
    try {
      print(message);
    } catch (e) {
      e.toString();
    }
  }
}

void showSnack(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(
    snackBar,
  );
}
