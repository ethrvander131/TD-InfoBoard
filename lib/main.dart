import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'Period.dart';
import 'SettingsPage.dart';

String _topMessage = "TOP MESSAGE";
String _bottomMessage = "BOTTOM MESSAGE";
String _image1Url = "";
String _image2Url = "";
final String graphicsBaseUrl = "http://splash.tdchristian.ca/apps/infoboard/";

List<Period> _periods = [];
bool grade9Mode = false;
bool hideTopMessage = false;
bool enableCustomPeriodNames = false;
final List<String> periodNames = [
  "PERIOD 1",
  "PERIOD 2",
  "PERIOD 3",
  "PERIOD 4"
];

final List<String> customPeriodNames = [
  "PERIOD 1",
  "PERIOD 2",
  "PERIOD 3",
  "PERIOD 4"
];

enum MenuChoices { refresh, settings }

void main() {
  runApp(new MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new InfoBoard(),
      theme: new ThemeData(primaryColor: Colors.green));
  }
}

class InfoBoard extends StatefulWidget {
  InfoBoard({Key key}) : super(key: key);

  @override
  _InfoBoardState createState() => new _InfoBoardState();
}

class _InfoBoardState extends State<InfoBoard> {

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

  @override
  Widget build(BuildContext context) {
    _getInfoBoard();

    _topMessage = _topMessage == "" ? "NO SCHOOL TODAY" : _topMessage;
    _bottomMessage = _bottomMessage == "" ? "NO MESSAGE": _bottomMessage;

    AppBar appBar = new AppBar(
      elevation: 0.0,
      backgroundColor: new Color(0xFFFFFF),
      title: new Text(
        hideTopMessage ? "" : _topMessage,
        textAlign: TextAlign.center,
        style: new TextStyle(
          fontFamily: "RobotoCondensed",
          fontSize: 24.0,
          fontWeight: FontWeight.w600
        ),
      ),
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
        ),
      ],
    );

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
    
    
    return new Stack(
      children: <Widget>[
        new Scaffold(
          appBar: hideTopMessage ? null : appBar,
          backgroundColor: Colors.green,
          body: new Column(
            children: [
              hideTopMessage ? new SizedBox(
                height: 30.0
              ) : new Container(),
              new Column(
                children: _periods.map((period) => new PeriodWidget(period)).toList(),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  image1,
                  image2
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
        hideTopMessage ? new Scaffold(
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
              ),
            ],
          ),
        ) : new Container()
      ]
    );
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
    var paddingMultiplier = hideTopMessage ? 2.5 : 2.0;

    String name = _period.name;

    if (enableCustomPeriodNames) {
      for (int i = 0; i < periodNames.length; i++) {
        if (_period.name.contains(periodNames[i])) {
          name = customPeriodNames[i]; 
        }
      }    
    }

    
    double padding = _periods.length * paddingMultiplier;
    return new Padding(
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
  }
}
Widget getCustomPeriodsFields() {

  List<Widget> periodFields = [];

  if (enableCustomPeriodNames && !grade9Mode) {
    for (int i = 0; i < periodNames.length; i++) {
      periodFields.add(new ListTile(
        title: new TextField(
          decoration: new InputDecoration(
            labelText: periodNames[i],
            hintText: customPeriodNames[i] ),
          onChanged: (String input) {
            customPeriodNames[i] = input;
          },
        )
      ));
    }
  } else if (enableCustomPeriodNames && grade9Mode) {
    
  }

  return new Column(
    children: periodFields
  );
}

