import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String msg;
  const LoadingDialog(this.msg);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: <Widget>[
          Text(
            msg,
            style: const TextStyle(fontSize: 14),
          ),
          const Spacer(),
          CupertinoActivityIndicator()
        ],
      ),
    );
  }
}
