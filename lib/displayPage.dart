import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usyd_app/browseClient.dart';
import 'package:usyd_app/helper.dart';
import 'sessionData.dart';

class DisplayPage extends StatefulWidget {
  BrowseClient client;

  DisplayPage(this.client, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DisplayPageState(client);
  }
}

class DisplayPageState extends State<DisplayPage> {
  BrowseClient client;
  String _infoState = 'infoMSG';
  String _barTitle = 'Message';
  bool _isSwitched;

  int _tabNumers = 0;
  List<Widget> _tabHeaders = [];
  List<Widget> _tabPages = [Text('NA')];

  @override
  initState() {
    _isSwitched = client.data.config['cached'];
    super.initState();
  }

  DisplayPageState(this.client);

  _doFunction() async {
    if (_infoState == 'infoMSG') {
      _barTitle = 'Message';
    }
    if (_infoState == 'infoRTS') {
      _barTitle = 'Requests';
    }
    if (_infoState == 'infoDLS') {
      _barTitle = 'Details';
    }
    if (_infoState == 'infoSDS') {
      _barTitle = 'Studies';
    }
    if (_infoState == 'infoRES') {
      _barTitle = 'Results';
      showWaitingDlg("Retrieving your ${_barTitle} information...", context);
      var results = json.decode((await client.getResults())['msg']);
      client.data.config['results'] = results;
      Navigator.of(context).pop();
      _tabNumers = 2;
      _tabHeaders = [Tab(child: Text('Past Units'),), Tab(child: Text('Summary Results'),)];
      _tabPages = [_genPage(1), _genPage(2)];
    }
    if (_infoState == 'infoFCE') {
      _barTitle = 'Finance';
    }
    if (_infoState == 'infoEXT') {
      _barTitle = 'Exit';
    }
    if (_infoState == 'infoSET') {
      _barTitle = 'Settings';
      _tabNumers = 0;
      _tabHeaders = null;
      _tabPages = [_genPage(0)];
    }
    if (_infoState == 'infoOUT') {
      _barTitle = 'Logout';
    }
  }

  _refreshPage() {}

  Widget _genResultUnitTable() {
    var results = client.data.config['results'];
    if (results == null) return Text("NA");
    var units, unitHeaders, unitBody, unitTail;
    units = results['units'];
    unitHeaders = units['headers'];
    unitBody = units['body'];
    unitTail = units['tail'];
    List<DataColumn> columns = [];
    List<DataRow> rows = [];

    for (String x in unitHeaders) {
      columns.add(DataColumn(label: Text(x)));
    }

    for (Map x in unitBody) {
      List<DataCell> cells = [];
      x.forEach((k, v) {
        String tmp = v;
        if (v == 'NA') tmp = 'Not Avaliable';
        if (v == 'S1C') tmp = 'Semester One';
        if (v == 'S2C') tmp = 'Semester Two';
        if (v == 'HD') tmp = 'High distinction';
        if (v == 'DI') tmp = 'Distinction';
        if (v == 'CR') tmp = 'Credit';
        if (v == 'PS') tmp = 'Pass';
        if (v == 'FA') tmp = 'Fail';
        if (v == 'AF') tmp = 'Absent fail';
        if (v == 'CN') tmp = 'Cancelled';
        if (v == 'DC') tmp = 'Discontinued not to count as failure';
        if (v == 'DF') tmp = 'Discontinue – fail';
        if (v == 'FR') tmp = 'Failed requirements';
        if (v == 'SR') tmp = 'Satisfied requirements';
        if (v == 'WD') tmp = 'Withdrawn';
        if (v == 'IC') tmp = 'Incomplete';
        if (v == 'RI') tmp = 'Result incomplete';
        if (v == 'UC') tmp = 'Unit of Study Continuing';

        cells.add(DataCell(Text(tmp)));
      });
      rows.add(DataRow(cells: cells));
    }

    return DataTable(
      columns: columns,
      rows: rows,
    );
  }

  Widget _genPage(int tabNum) {
    Widget pageWidget = Text('NA');
    if (_infoState == 'infoMSG') {}
    if (_infoState == 'infoRTS') {}
    if (_infoState == 'infoDLS') {}
    if (_infoState == 'infoSDS') {}
    if (_infoState == 'infoRES') {
      /*var results = client.data.config['results'];
      var units, averages, unitHeaders, unitBody, unitTail, aveHeaders, aveBody, aveTail;
      units = results['units'];
      averages = results['averages'];
      unitHeaders = units['headers'];
      unitBody = units['body'];
      unitTail = units['tail'];
      aveHeaders = averages['headers'];
      aveBody = averages['body'];
      aveTail = averages['tail'];*/
      if(tabNum ==1){
        pageWidget = SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _genResultUnitTable(),
          ),
        );
      }

      if(tabNum==2){
        pageWidget = Text('Not Done');
      }
    }
    if (_infoState == 'infoFCE') {}
    if (_infoState == 'infoEXT') {}
    if (_infoState == 'infoSET') {
      pageWidget = Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_isSwitched ? 'Cached View: On:' : 'Cached View: Off:'),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  Switch(
                    value: false, //Implement
                    onChanged: (val) {
                      setState(() {
                        //_isSwitched = val;
                      });
                    },
                  )
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Check Update:',
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  RaisedButton(
                    child: Text('Update'),
                    onPressed: () {},
                  )
                ],
              ),
              Divider(),
              Wrap(
                //alignment: WrapAlignment.center,
                children: <Widget>[
                  Text(r'''
About the usydApp (Ver 0.1):
                  
SDKs uses:
                    
flutter: 1.12.13+hotfix.8
http: ^0.12.0+4
fluttertoast: ^3.1.3
html: ^0.14.0+3
cupertino_icons: ^0.1.2
path_provider: ^1.6.5
url_launcher: ^5.4.2
                      
Please beware that this is an open source software.
The usage of the code or software is constrained by SDKs' licenses.
                    '''),
                ],
              ),
              Divider(),
              InkWell(
                child: Text(
                  'Source on Github',
                  style: TextStyle(
                    color: Color(0xFFE64626),
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () async {
                  await launch('https://github.com/shipherd/usydApp');
                },
              )
            ],
          ),
        ),
      );
    }
    if (_infoState == 'infoOUT') {}

    return pageWidget;
  }

  Widget buildUI(BuildContext context) {
    return DefaultTabController(
        length: _tabNumers,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_barTitle),
            bottom: TabBar(
              tabs: _tabHeaders,
            ),
            leading: Builder(builder: (context) {
              return IconButton(
                icon: Icon(Icons.list),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
            actions: <Widget>[
              FlatButton(
                child: Text('Refresh'),
                onPressed: () {
                  setState(() {
                    _refreshPage();
                  });
                },
              ),
            ],
          ),
          body: TabBarView(
            children: _tabPages,
          ),
          drawer: new Drawer(
              child: new ListView(
                children: <Widget>[
                  new Divider(),
                  new ListTile(
                    trailing: _infoState == 'infoMSG'
                        ? Icon(Icons.keyboard_arrow_right)
                        : null,
                    leading: Icon(Icons.info),
                    subtitle: Text("new or unread messages"),
                    title: new Text(
                      'Messages',
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      _infoState = 'infoMSG';
                      Navigator.of(context).pop(); //pop the drawer
                      setState(() {});
                    },
                  ),
                  new ListTile(
                    trailing: _infoState == 'infoRTS'
                        ? Icon(Icons.keyboard_arrow_right)
                        : null,
                    leading: Icon(Icons.swap_vert),
                    title: new Text(
                      'Requests',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text('approval requests'),
                    onTap: () {
                      _infoState = 'infoRTS';
                      Navigator.of(context).pop(); //pop the drawer
                      setState(() {});
                    },
                  ),
                  new ListTile(
                    trailing: _infoState == 'infoDLS'
                        ? Icon(Icons.keyboard_arrow_right)
                        : null,
                    leading: Icon(Icons.person),
                    subtitle: Text('personal details'),
                    title: new Text(
                      'Details',
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      _infoState = 'infoDLS';
                      Navigator.of(context).pop(); //pop the drawer
                      setState(() {});
                    },
                  ),
                  new ListTile(
                    trailing: _infoState == 'infoSDS'
                        ? Icon(Icons.keyboard_arrow_right)
                        : null,
                    leading: Icon(Icons.book),
                    subtitle: Text('courses and past results'),
                    title: new Text(
                      'Studies',
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      _infoState = 'infoSDS';
                      Navigator.of(context).pop(); //pop the drawer
                      setState(() {});
                    },
                  ),
                  new ListTile(
                    trailing: _infoState == 'infoRES'
                        ? Icon(Icons.keyboard_arrow_right)
                        : null,
                    leading: Icon(Icons.check),
                    subtitle: Text('latest results of study'),
                    title: new Text(
                      'Results',
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () async {
                      _infoState = 'infoRES';
                      Navigator.of(context).pop(); //pop the drawer
                      await _doFunction();
                      setState(() {});
                    },
                  ),
                  new ListTile(
                    trailing: _infoState == 'infoFCE'
                        ? Icon(Icons.keyboard_arrow_right)
                        : null,
                    leading: Icon(Icons.attach_money),
                    subtitle: Text('any money related details'),
                    title: new Text(
                      'Finance',
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      _infoState = 'infoFCE';
                      Navigator.of(context).pop(); //pop the drawer
                      setState(() {});
                    },
                  ),
                  new Divider(),
                  new ListTile(
                    trailing: _infoState == 'infoSET'
                        ? Icon(Icons.keyboard_arrow_right)
                        : null,
                    leading: Icon(Icons.settings),
                    title: new Text(
                      'Settings',
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      _infoState = 'infoSET';
                      Navigator.of(context).pop(); //pop the drawer
                      setState(() {});
                    },
                  ),
                  new Divider(),
                  new ListTile(
                    leading: Icon(Icons.keyboard_arrow_left),
                    title: new Text(
                      'Logout',
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      _infoState = 'infoOUT';
                      Navigator.of(context).pop(); //pop the drawer
                      setState(() {});
                    },
                  ),
                  new ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: new Text(
                      'Exit',
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      _infoState = 'infoEXT';
                      Navigator.of(context).pop(); //pop the drawer
                      setState(() {});
                    },
                  ),
                  new Divider(),
                ],
          )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(child: buildUI(context), onWillPop: () async => false);
  }
}
