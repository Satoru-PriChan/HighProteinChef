import 'package:flutter/material.dart';

class AppRouter {
    static void showDialogs(BuildContext context, String message, void Function() onTapOK, {String title = "Error"}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                onTapOK();
              }, 
              child: Text("OK"))
          ],
        );
      });
    });
  }
}