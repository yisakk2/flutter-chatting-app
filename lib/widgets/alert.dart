import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


alert(BuildContext context, String title, String content) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Theme(
          data: ThemeData.dark(),
          child: CupertinoAlertDialog(
            title: Text(title),
            content: Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(content, style: TextStyle(color: Colors.grey),),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('확인'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      }
  );
}