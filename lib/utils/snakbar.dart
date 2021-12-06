import 'package:authentification/utils/my_print.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Snakbar{
  static Snakbar? _instance;

  factory Snakbar() {
    if(_instance == null) {
      _instance = Snakbar._();
    }
    return _instance!;
  }

  Snakbar._();

  void show_success_snakbar(BuildContext context, String success_message){
    try {
      /*showOverlayNotification(
            (context) {
          return SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.all(MySize.size10!),
                child: CustomSnackBar.success(message: success_message),
              ),
            ),
          );
        },
        duration: Duration(seconds: 3),
        position: NotificationPosition.top,
      );*/
      showTopSnackBar(
        context,
        CustomSnackBar.success(
          message:success_message,
        ),
      );
    }
    catch(e) {
      MyPrint.printOnConsole("Error in Showing Success Snakbar:${e}");
    }
  }
  void show_info_snakbar(BuildContext context, String info_message){
    try {
      showTopSnackBar(
        context,
        CustomSnackBar.info(
          message:info_message,
        ),
      );
    }
    catch(e) {
      MyPrint.printOnConsole("Error in Showing Info Snakbar:${e}");
    }
  }
  void show_error_snakbar(BuildContext context, String error_message){
    try {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: error_message,
        ),
      );
    }
    catch(e) {
      MyPrint.printOnConsole("Error in Showing Error Snakbar:${e}");
    }
  }
}