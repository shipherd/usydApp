import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:usyd_app/displayPage.dart';
import 'package:usyd_app/sessionData.dart';
import 'helper.dart';
import 'browseClient.dart';
import 'dart:convert';

class loginPage extends StatefulWidget {
  SessionData data;
  loginPage(SessionData data, {Key key}) : super(key: key){
    this.data = data;
  }

  loginPageState createState() => new loginPageState(data);
}

class loginPageState extends State<loginPage> {
  SessionData data;
  loginPageState(SessionData data){
    this.data = data;
  }
  TextEditingController _unikeyControl = new TextEditingController();
  TextEditingController _pwControl = new TextEditingController();
  FocusNode _uniKeyFocus = new FocusNode();
  FocusNode _pwFocus = new FocusNode();

  void initState() {
    _uniKeyFocus.addListener(() {
      setState(() {});
    });
    _pwFocus.addListener(() {
      setState(() {});
    });
    _unikeyControl.text = data.config['unikey'];
    _pwControl.text = data.config['password'];
    super.initState();
  }

  void dispose() {
    _uniKeyFocus.dispose();
    _pwFocus.dispose();
    super.dispose();
  }

  var _keyValidate = true;
  var _pwValidate = true;


  void _login() async{
    if (_unikeyControl.text.length <= 0) {
      setState(() {
        _keyValidate = false;
      });
      return;
    } else {
      setState(() {
        _keyValidate = true;
      });
    }

    if (_pwControl.text.length <= 0) {
      setState(() {
        _pwValidate = false;
      });
      return;
    } else {
      setState(() {
        _pwValidate = true;
      });
    }


    var client = new BrowseClient(data);

    try {
      showWaitingDlg('Logining in...', context);

      var ret = await client.getLogin(_unikeyControl.text, _pwControl.text);
      Navigator.of(context, rootNavigator: true).pop();

      /*if(ret['code']!=ERROR_SUCCESS){
        showBottomMsg(ret['msg']);
        return;
      }*/
      data.config['unikey'] = _unikeyControl.text;
      data.config['password'] = _pwControl.text;
      data.configFile.delete();
      data.configFile.writeAsStringSync(jsonEncode(data.config));
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context){
          return DisplayPage(client);
        }
      ));
    } catch (e) {
      Navigator.of(context).pop();
      debugPrint(e.toString());
      showBottomMsg(e.toString());
    }
  }



  Widget buildLoginForm(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          image: AssetImage('assets/banner_logo.png'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
        ),
        Container(
          //color: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                  focusNode: _uniKeyFocus,
                  controller: _unikeyControl,
                  //enabled: !_isLogin,
                  onChanged: (str) {
                    var tmp = true;
                    if (str.length >= 0)
                      tmp = true;
                    else
                      tmp = false;
                    setState(() {
                      _keyValidate = tmp;
                    });
                  },
                  decoration: InputDecoration(
                      errorText: _keyValidate ? null : "Can't Be Empty",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0xFFE64626))),
                      labelText: 'UniKey',
                      labelStyle: TextStyle(
                          color: _uniKeyFocus.hasFocus
                              ? Color(0xFFE64626)
                              : Color(0xFF868686)),
                      //hintText: 'Enter Your UniKey Here',
                      icon: Icon(
                        Icons.person,
                        color: _uniKeyFocus.hasFocus
                            ? Color(0xFFE64626)
                            : Color(0xFF868686),
                      ))),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
              ),
              TextField(
                focusNode: _pwFocus,
                obscureText: true,
                textInputAction: TextInputAction.go,
                controller: _pwControl,

                //enabled: !_isLogin,
                onChanged: (str) {
                  var tmp = true;
                  if (str.length >= 0)
                    tmp = true;
                  else
                    tmp = false;
                  setState(() {
                    _pwValidate = tmp;
                  });
                },
                decoration: InputDecoration(
                    errorText: _pwValidate ? null : "Can't Be Empty",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xFFE64626))),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        color: _pwFocus.hasFocus
                            ? Color(0xFFE64626)
                            : Color(0xFF868686)),
                    //hintText: 'Enter Your Password Here',
                    icon: Icon(
                      Icons.lock,
                      color: _pwFocus.hasFocus
                          ? Color(0xFFE64626)
                          : Color(0xFF868686),
                    )),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*_isLogin
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Color(0xFFE64626)),
                        )
                      : FlatButton(
                          color: Color(0xFFE64626),
                          highlightColor: Colors.orangeAccent,
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.orangeAccent,
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          onPressed: _login),*/
                  FlatButton(
                      color: Color(0xFFE64626),
                      highlightColor: Colors.orangeAccent,
                      colorBrightness: Brightness.dark,
                      splashColor: Colors.orangeAccent,
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      onPressed: _login),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  FlatButton(
                    color: Color(0xFFE64626),
                    highlightColor: Colors.orangeAccent,
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.orangeAccent,
                    child: Text(
                      "Exit",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildUI(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: new AppBar(
        leading: Icon(Icons.transfer_within_a_station),
        title: new Text('Login'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildLoginForm(context),
        color: Color(0xFFE64626),
      ),
    );
  }

  Widget buildPage(BuildContext context) {
    return new Container(
      child: buildUI(context),
    );
  }

  Widget build(BuildContext context) {
    return buildUI(context);
  }
}
