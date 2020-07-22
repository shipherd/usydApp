import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:usyd_app/sessionData.dart';
import 'loginPage.dart';
import 'package:path_provider/path_provider.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  SessionData data = SessionData();

  Directory d = await getApplicationDocumentsDirectory();
  File configFile = File(d.path+"/config.json");
  //configFile.deleteSync();
  bool exists = await configFile.exists();

  if(!exists){
    configFile.writeAsStringSync('''
    
    {
      "cached":false,
      "unikey":"bpen8455",
      "password":"0123Asdf"
    }
    
        ''', flush:true);
    configFile = File(d.path+"/config.json");
  }

  Map config = jsonDecode(await configFile.readAsStringSync());
  print(config);

  data.config = config;
  data.configFile = configFile;
  runApp(new appEntry(data));
}

class appEntry extends StatelessWidget{
  SessionData data;
  appEntry(this.data);
  Widget build(BuildContext context) {


    return MaterialApp(
      title:'APP',
        home: new loginPage(data),
      theme: ThemeData(
        primaryColor: Colors.white
      ),
    );
  }
}
