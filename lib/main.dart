import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'period.dart';

bool grade9Mode;
bool hideTopMessage = false;
bool enableCustomPeriodNames = false;

String _topMessage = "TOP MESSAGE";
String _bottomMessage = "BOTTOM MESSAGE";
String _image1Url = "";
String _image2Url = "";
final String graphicsBaseUrl = "http://splash.tdchristian.ca/apps/infoboard/";

List<String> customPeriodNames;
List<String> customPeriodNamesDay2;
List<Period> _periods = [];
<<<<<<< HEAD
<<<<<<< HEAD

=======
bool grade9Mode = false;
bool hideTopMessage = false;
bool enableCustomPeriodNames = false;
>>>>>>> parent of 19f805f... Data is now persistent, Grade 9 Mode works, cleaned up code
final List<String> periodNames = [
  "PERIOD 1",
  "PERIOD 2",
  "PERIOD 3",
  "PERIOD 4"
];

<<<<<<< HEAD
=======
final List<String> customPeriodNames = [
  "PERIOD 1",
  "PERIOD 2",
  "PERIOD 3",
  "PERIOD 4"
=======
bool _grade9Mode = false;
bool _hideTopMessage = false;
bool _enableCustomPeriodNames = false;
final List<String> periodNames = [
  "Period 1",
  "Period 2",
  "Period 3",
  "Period 4"
>>>>>>> parent of 83df8ed... Custom period names now work
];
List<CustomPeriod> _customPeriods;
List<CustomPeriod> _customPeriodsGrade9;
Row _customPeriodNameFields;

>>>>>>> parent of 19f805f... Data is now persistent, Grade 9 Mode works, cleaned up code
enum MenuChoices { refresh, settings }

class CustomPeriod {
  String originalName;
  String customName;

  CustomPeriod(String _originalName, String _customName) {
    this.originalName = _originalName;
    this.customName = _customName;
  }
}

void main() {
  runApp(new MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
<<<<<<< HEAD
<<<<<<< HEAD
        title: "TDChristian InfoBoard",
        home: new InfoBoard(),
        theme: new ThemeData(primaryColor: Colors.green));
=======
      home: new InfoBoard(),
      theme: new ThemeData(primaryColor: Colors.green));
>>>>>>> parent of 19f805f... Data is now persistent, Grade 9 Mode works, cleaned up code
=======
        home: new InfoBoard(),
        theme: new ThemeData(primaryColor: Colors.green));
>>>>>>> parent of 83df8ed... Custom period names now work
  }
}

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class InfoBoard extends StatefulWidget {
  InfoBoard({Key key}) : super(key: key);

  @override
  _InfoBoardState createState() => new _InfoBoardState();
}

class _InfoBoardState extends State<InfoBoard> {
<<<<<<< HEAD
  @override
  void initState() {
    super.initState();
    _getUserData();
    _getInfoBoard();
  }
=======
>>>>>>> parent of 19f805f... Data is now persistent, Grade 9 Mode works, cleaned up code

  _getInfoBoard() async {
    final String url =
        'http://splash.tdchristian.ca/apps/if2/getScreenData.php';
    HttpClient httpClient = new HttpClient();

    String topMessage;
    String bottomMessage;
    String image1Url;
    String image2Url;
    List<Period> periods;

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(UTF8.decoder).join();
        var data = JSON.decode(json);
        topMessage = data['5'][1];
        bottomMessage = data['6'][1];
        image1Url = data['7'];
        image2Url = data['8'];
        periods = getPeriods(data['4']);
      }
    } catch (exception) {
      print(exception);
    }

    if (!mounted) return;

    setState(() {
      _topMessage = topMessage;
      _bottomMessage = bottomMessage;
      _periods = periods;
      _image1Url = image1Url;
      _image2Url = image2Url;
    });
  }

  List<Period> getPeriods(List<List<String>> periodsList) {
    List<Period> periods = [];

    if (periodsList.length > 0) {
      for (var p in periodsList) {
        periods.add(new Period(p[0], p[1], p[2]));
      }
    }
    return periods;
  }

<<<<<<< HEAD
  _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    grade9Mode = prefs.getBool('grade9Mode') ?? false;
    hideTopMessage = prefs.getBool('hideTopMessage') ?? false;
    enableCustomPeriodNames = prefs.getBool('enableCustomPeriodNames') ?? false;
    customPeriodNames = prefs.getStringList('customPeriodNames') ??
        ["PERIOD 1", "PERIOD 2", "PERIOD 3", "PERIOD 4"];

    customPeriodNamesDay2 = prefs.getStringList('customPeriodNames2') ??
        ["PERIOD 1", "PERIOD 2", "PERIOD 3", "PERIOD 4"];
  }

  _saveValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('grade9Mode', grade9Mode);
    prefs.setBool('hideTopMessage', hideTopMessage);
    prefs.setBool('enableCustomPeriodNames', enableCustomPeriodNames);
    prefs.setStringList('customPeriodNames', customPeriodNames);
    prefs.setStringList('customPeriodNamesDay2', customPeriodNamesDay2);
  }

  @override
  Widget build(BuildContext context) {
=======
  @override
  Widget build(BuildContext context) {
    _getInfoBoard();

<<<<<<< HEAD
>>>>>>> parent of 19f805f... Data is now persistent, Grade 9 Mode works, cleaned up code
    _topMessage = _topMessage == "" ? "NO SCHOOL TODAY" : _topMessage;
    _bottomMessage = _bottomMessage == "" ? "NO MESSAGE" : _bottomMessage;

<<<<<<< HEAD
    _saveValues();
=======
    _topMessage = "TOP MESSAGE";
    _bottomMessage = "BOTTOM MESSAGE";
>>>>>>> parent of 83df8ed... Custom period names now work

    AppBar appBar = new AppBar(
      elevation: 0.0,
      backgroundColor: new Color(0xFFFFFF),
      title: new Padding(
          padding: new EdgeInsets.only(left: 24.0),
          child: new Text(
            hideTopMessage ? "" : _topMessage,
            textAlign: TextAlign.center,
            style: new TextStyle(
                fontFamily: "RobotoCondensed",
                fontSize: 24.0,
                fontWeight: FontWeight.w600),
          )),
=======
    AppBar appBar = new AppBar(
      elevation: 0.0,
      backgroundColor: new Color(0xFFFFFF),
      title: new Text(
        _hideTopMessage ? "" : _topMessage,
        textAlign: TextAlign.center,
        style: new TextStyle(
          fontFamily: "RobotoCondensed",
          fontSize: 24.0,
          fontWeight: FontWeight.w600
        ),
      ),
>>>>>>> parent of 19f805f... Data is now persistent, Grade 9 Mode works, cleaned up code
      actions: <Widget>[
        new PopupMenuButton<MenuChoices>(
            onSelected: (MenuChoices result) {
              setState(() {
                if (result == MenuChoices.refresh) {
                  _getInfoBoard();
                } else if (result == MenuChoices.settings) {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new SettingsPage()));
                }
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<MenuChoices>>[
                  new PopupMenuItem<MenuChoices>(
                    value: MenuChoices.refresh,
                    child: new ListTile(
                      leading: new Icon(Icons.refresh),
                      title: new Text('REFRESH'),
                    ),
                  ),
                  new PopupMenuItem<MenuChoices>(
                      value: MenuChoices.settings,
                      child: new ListTile(
                          leading: new Icon(Icons.settings),
                          title: new Text("SETTINGS")))
                ]),
      ],
    );
<<<<<<< HEAD

    Image image1;
    Image image2;

    try {
      image1 = new Image.network(
        _image1Url != ""
            ? graphicsBaseUrl + _image1Url
            : "http://splash.tdchristian.ca/apps/infoboard/graphics//HappyFace.gif",
        height: 100.0,
      );
      image2 = new Image.network(
          _image2Url != ""
              ? graphicsBaseUrl + _image2Url
              : "http://splash.tdchristian.ca/apps/infoboard/graphics//HappyFace.gif",
          height: 100.0);
    } catch (exception) {
      print(exception);
    }

    return new Stack(children: <Widget>[
      new Scaffold(
        appBar: hideTopMessage ? null : appBar,
        backgroundColor: Colors.green,
        body: new Column(children: [
          hideTopMessage ? new SizedBox(height: 30.0) : new Container(),
          new Column(
            children:
                _periods.map((period) => new PeriodWidget(period)).toList(),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [image1, image2],
          ),
          new Expanded(
              child: new Padding(
            padding: const EdgeInsets.all(12.0),
            child: new Container(
              decoration: new BoxDecoration(
                  color: Colors.green[700],
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(12.0))),
              child: new Center(
                  heightFactor: 5.0,
                  child: new Text(_bottomMessage,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontFamily: "RobotoCondensed",
                          fontSize: 22.0,
                          color: Colors.white))),
            ),
          ))
        ]),
      ),
      hideTopMessage
          ? new Scaffold(
              backgroundColor: new Color(0xFFFFFF),
              appBar: new AppBar(
                backgroundColor: new Color(0xFFFFFF),
                elevation: 0.0,
                actions: <Widget>[
                  new PopupMenuButton<MenuChoices>(
                      onSelected: (MenuChoices result) {
                        setState(() {
                          if (result == MenuChoices.refresh) {
                            _getInfoBoard();
                          } else if (result == MenuChoices.settings) {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new SettingsPage()));
                          }
                        });
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<MenuChoices>>[
                            new PopupMenuItem<MenuChoices>(
                              value: MenuChoices.refresh,
                              child: new ListTile(
                                leading: new Icon(Icons.refresh),
                                title: new Text('REFRESH'),
                              ),
                            ),
                            new PopupMenuItem<MenuChoices>(
                                value: MenuChoices.settings,
                                child: new ListTile(
                                    leading: new Icon(Icons.settings),
                                    title: new Text("SETTINGS")))
                          ]),
                ],
=======
    
    return new Stack(
      children: <Widget>[
        new Scaffold(
          appBar: _hideTopMessage ? null : appBar,
          backgroundColor: Colors.green,
          body: new Column(
            children: [
              _hideTopMessage ? new SizedBox(
                height: 30.0
              ) : new Container(),
              new Column(
                children: _periods.map((period) => new PeriodWidget(period)).toList(),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new Image.network(
                    _image1Url != ""
                        ? graphicsBaseUrl + _image1Url
                        : "http://splash.tdchristian.ca/apps/infoboard/graphics//HappyFace.gif",
                    height: 100.0,
                  ),
                  new Image.network(
                      _image2Url != ""
                          ? graphicsBaseUrl + _image2Url
                          : "http://splash.tdchristian.ca/apps/infoboard/graphics//HappyFace.gif",
                      height: 100.0),
                ],
              ),
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: new Container(
                    decoration: new BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: new BorderRadius.all(new Radius.circular(12.0))
                    ),
                    child: new Center(
                      heightFactor: 5.0,
                      child: new Text(_bottomMessage,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontFamily: "RobotoCondensed",
                          fontSize: 22.0,
                          color: Colors.white
                        )
                      )
                    ),
                  ),
                )
              )
            ]
          ),
        ),
        _hideTopMessage ? new Scaffold(
          backgroundColor: new Color(0xFFFFFF),
          appBar: new AppBar(
            backgroundColor: new Color(0xFFFFFF),
            elevation: 0.0,
            actions: <Widget>[
              new PopupMenuButton<MenuChoices>(
                onSelected: (MenuChoices result) {
                  setState(() {
                    if (result == MenuChoices.refresh) {
                      _getInfoBoard();
                    } else if (result == MenuChoices.settings) {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => new SettingsPage()
                        )
                      );
                    }
                  });
                },
                itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<MenuChoices>>[
                    new PopupMenuItem<MenuChoices>(
                      value: MenuChoices.refresh,
                      child: new ListTile(
                        leading: new Icon(Icons.refresh),
                        title: new Text('REFRESH'),
                      ),
                    ),
                    new PopupMenuItem<MenuChoices>(
                      value: MenuChoices.settings,
                      child: new ListTile(
                        leading: new Icon(Icons.settings),
                        title: new Text("SETTINGS")
                      )
                    )
                  ]
>>>>>>> parent of 83df8ed... Custom period names now work
              ),
            )
          : new Container()
    ]);
  }
}

class PeriodWidget extends StatelessWidget {
  final Period _period;
  PeriodWidget(this._period);

  String change24HourTo12Hour(String time24) {
    int colonIndex = time24.indexOf(':');
    int hour = int.parse(time24.substring(0, colonIndex));
    int minute = int.parse(time24.substring(colonIndex + 1));

    var dateTime = new DateTime(0, 0, 0, hour, minute);
    var formatter = new DateFormat('K:m');
    String time12 = formatter.format(dateTime);

    if (minute < 10) {
      colonIndex = time12.indexOf(":");
      String minuteString = "0" + minute.toString();
      return time12.replaceRange(colonIndex + 1, time12.length, minuteString);
    } else {
      return time12;
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    var paddingMultiplier = hideTopMessage ? 2.5 : 2.0;

    String name = _period.name;

    if (enableCustomPeriodNames) {
<<<<<<< HEAD
       if (grade9Mode && _topMessage.contains("DAY 2")) {
        for (int i = 0; i < periodNames.length; i++) {
          if (_period.name.contains(periodNames[i])) {
            name = customPeriodNamesDay2[i];
          }
        }
      } else {
        for (int i = 0; i < periodNames.length; i++) {
          if (_period.name.contains(periodNames[i])) {
            name = customPeriodNames[i];
          }
        }
      }

=======
      for (int i = 0; i < periodNames.length; i++) {
        if (_period.name.contains(periodNames[i])) {
          name = customPeriodNames[i]; 
        }
      }    
>>>>>>> parent of 19f805f... Data is now persistent, Grade 9 Mode works, cleaned up code
    }

    double padding = _periods.length * paddingMultiplier;
    return new Padding(
<<<<<<< HEAD
        padding: new EdgeInsets.only(
            top: padding, bottom: padding, left: 40.0, right: 35.0),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Text(name.toUpperCase(),
=======
    var paddingMultiplier = _hideTopMessage ? 2.5 : 2.0;
    return new Padding(
        padding: new EdgeInsets.all(_periods.length * paddingMultiplier),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Text(_period.name,
>>>>>>> parent of 83df8ed... Custom period names now work
                  style: new TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "RobotoCondensed",
                      fontSize: 24.0,
                      color: Colors.white),
<<<<<<< HEAD
                  textAlign: TextAlign.left),
              new Expanded(
                child: new Container(),
              ),
              new Container(
                width: 120.0,
                child: new Text(
                    change24HourTo12Hour(_period.startTime) +
                        " - " +
                        change24HourTo12Hour(_period.endTime),
                    style: new TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: "RobotoCondensed",
                        fontSize: 24.0,
                        color: Colors.white),
                    textAlign: TextAlign.left),
              ),
            ]));
=======
      padding: new EdgeInsets.only(top: padding, bottom: padding),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Text(name.toUpperCase(),
            style: new TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: "RobotoCondensed",
              fontSize: 24.0,
              color: Colors.white
            ),
            textAlign: TextAlign.center
          ),
          new Text(
            change24HourTo12Hour(_period.startTime) +
              " - " +
              change24HourTo12Hour(_period.endTime),
            style: new TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: "RobotoCondensed",
              fontSize: 24.0,
              color: Colors.white
            ),
            textAlign: TextAlign.center
          ),
        ]
      )
    );
>>>>>>> parent of 19f805f... Data is now persistent, Grade 9 Mode works, cleaned up code
  }
}

Widget getCustomPeriodsFields() {
  List<Widget> periodFields = [];

  if (enableCustomPeriodNames && !grade9Mode) {
    for (int i = 0; i < periodNames.length; i++) {
      periodFields.add(new ListTile(
<<<<<<< HEAD
        dense: true,
        leading: new Text(
          periodNames[i],
          style: new TextStyle(fontSize: 12.0),
        ),
        title: new TextField(
          decoration: new InputDecoration(
              labelText: customPeriodNames[i],
              labelStyle: new TextStyle(color: Colors.black87)),
          onChanged: (String input) {
            customPeriodNames[i] = input;
          },
        ),
      ));
    }
  }
  if (grade9Mode) {
    periodFields.insert(
        0,
        new Padding(
            padding: new EdgeInsets.only(top: 8.0),
            child: new Text("DAY 1",
                style: new TextStyle(fontSize: 16.0, color: Colors.black54))));
    periodFields.add(new SizedBox(
      height: 16.0,
    ));
    periodFields.add(new Divider());
    periodFields.add(new Padding(
        padding: new EdgeInsets.only(top: 8.0),
        child: new Text("DAY 2",
            style: new TextStyle(fontSize: 16.0, color: Colors.black54))));

    for (int i = 0; i < periodNames.length; i++) {
      periodFields.add(new ListTile(
        dense: true,
        leading: new Text(
          periodNames[i],
          style: new TextStyle(fontSize: 12.0),
        ),
        title: new TextField(
          decoration: new InputDecoration(
              labelText: customPeriodNamesDay2[i],
              labelStyle: new TextStyle(color: Colors.black87)),
          onChanged: (String input) {
            customPeriodNamesDay2[i] = input;
          },
        ),
=======
        title: new TextField(
          decoration: new InputDecoration(
            labelText: periodNames[i],
            hintText: customPeriodNames[i] ),
          onChanged: (String input) {
            customPeriodNames[i] = input;
          },
        )
>>>>>>> parent of 19f805f... Data is now persistent, Grade 9 Mode works, cleaned up code
      ));
=======
                  textAlign: TextAlign.center),
              new Text(
                  change24HourTo12Hour(_period.startTime) +
                      " - " +
                      change24HourTo12Hour(_period.endTime),
                  style: new TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "RobotoCondensed",
                      fontSize: 24.0,
                      color: Colors.white),
                  textAlign: TextAlign.center),
            ]));
  }
}

List<Period> getPeriods(List<List<String>> periodsList) {
  List<Period> periods = [];

  if (periodsList.length > 0) {
    for (var p in periodsList) {
      periods.add(new Period(p[0], p[1], p[2]));
>>>>>>> parent of 83df8ed... Custom period names now work
    }
  }

<<<<<<< HEAD
  return new Column(children: periodFields);
}
=======
  return periods;
}

class _SettingsPageState extends State<SettingsPage> {

  void setCustomPeriodNames() {

  }

  @override
  Widget build(BuildContext context) {
    Divider divider = new Divider();

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Settings'),
          elevation: 0.0,
        ),
        body: new ListView(
          children: <Widget>[
            new SizedBox(height: 8.0),
            new ListTile(
              title: new Text("Hide Day 1/Day 2 Message"),
              trailing: new Switch(
                value: _hideTopMessage,
                onChanged: (bool newValue) {
                  setState(() {
                    _hideTopMessage = newValue;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            divider,
            new ListTile(
              title: new Text("Enable custom period names"),
              trailing: new Switch(
                value: _enableCustomPeriodNames,
                onChanged: (bool newValue) {
                  setState(() {
                    _enableCustomPeriodNames = newValue;
                  });
                },
                activeColor: Colors.green,
              ),
            ),
            divider,
            _enableCustomPeriodNames
                ? new ListTile(
                    enabled: _enableCustomPeriodNames,
                    title: new Text("Enable Grade 9 Mode"),
                    subtitle: new Padding(
                        padding: new EdgeInsets.only(top: 3.0),
                        child: new Text(
                            "This will enable changing Day 1 & 2 classes")),
                    trailing: new Switch(
                      value: _grade9Mode,
                      onChanged: (bool newValue) {
                        setState(() {
                          _grade9Mode = newValue;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  )
                : new Container(),
            _enableCustomPeriodNames ? divider : new Container(),
          ],
        ));
  }
}
>>>>>>> parent of 83df8ed... Custom period names now work
