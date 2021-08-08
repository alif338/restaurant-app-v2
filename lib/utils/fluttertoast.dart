import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastLength{SHORT, LONG}

void showToast({String message = "", ToastLength length = ToastLength.SHORT}) async {
  if (kIsWeb) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  } else {
    const platform = const MethodChannel("toast.flutter.io/toast");
    try {
      if (length == ToastLength.SHORT) {
        final res = await platform.invokeMethod("showToastShort", message);
        print(res.toString());
      } else {
        final res = await platform.invokeMethod("showToastLong", message);
        print(res.toString());
      }
    } on PlatformException catch(e) {
      print(e.message);
    }
  }
}