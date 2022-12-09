import 'package:flutter/material.dart';

class Loader {
  BuildContext context;

  Loader(this.context);

  void startLoading() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
        barrierDismissible: false,
        barrierColor: Colors.transparent);
  }

  void stopLoading() async {
    Navigator.of(context).pop();
  }
}
