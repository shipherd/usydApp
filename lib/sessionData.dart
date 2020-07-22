import 'dart:io';
class SessionData{
  int token ;
  Map config;
  File configFile;
  SessionData(){
    token = 0;
    config = {};
    configFile = File('');
  }
}