import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart';
import 'sessionData.dart';
import 'helper.dart';

class BrowseClient {
  SessionData data;
  BrowseClient(this.data);
  _makeFunction(int func){
    return {"token":data.token, "function":func};
  }
  _postFunction(bool isLogin, Map data)async {
    if (await (Connectivity().checkConnectivity())==ConnectivityResult.none){
      throw new Exception('No network');
    }
    Response r = await post("http://10.0.2.2:8080/"+(isLogin?"login":"do"),
        headers: {"Accept":"application/json"},
        encoding: Encoding.getByName('utf-8'),body: json.encode(data));
    return json.decode(r.body);
  }
  getLogin(String unikey, String password) async{
    Map ret = await _postFunction(true, {"unikey":unikey,"pw":password});
    data.token = ret['token'];
    return ret;
  }
  getResults()async{
    Map ret = await _postFunction(false, _makeFunction(FUNC_RESULT));
    return ret;
  }

}
