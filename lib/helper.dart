import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
const ERROR_SUCCESS = 0;
const ERROR_NETWORK = -1;
const ERROR_UNIKEY_OR_PW = -2;
const ERROR_POST_PARAMS = -3;
const ERROR_SESSION_EXPIRED = -4;
const ERROR_OBJ_NOTFOUND = -5;
const ERROR_SERVER = -6;
const FUNC_NOTICE = 0;
const FUNC_RESULT = 1;
const FUNC_DETAILS= 2;

showBottomMsg(var Msg) {
  Fluttertoast.showToast(
      msg: Msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.blue,
      textColor: Color(0xFFFFFFFF),
      fontSize: 16.0,
  );
}

showWaitingDlg(String msg, context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.symmetric(vertical: 15),),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Color(0xFFE64626)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  Text(msg)
                ],
              ),
            )
          ],
        );
      });
}