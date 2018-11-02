import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'period.dart';
import 'SettingsPage.dart';
import 'package:auto_size_text/auto_size_text.dart';

bool grade9Mode = false;
bool hideTopMessage = false;
bool enableCustomPeriodNames = true;
bool isSchoolToday = false;
bool failedToGetInfoBoard = true;
bool attemptedGetInfoBoard = false;

PeriodWidget currentPeriod;

DateTime lastChecked;

String _topMessage = "TOP MESSAGE";
String _bottomMessage = "BOTTOM MESSAGE";
String _image1Url = "";
String _image2Url = "";
final String graphicsBaseUrl = "http://splash.tdchristian.ca/apps/infoboard/";

List<String> customPeriodNames;
List<String> customPeriodNamesDay2;
List<Period> _periods = [];

final List<String> periodNames = [
  "PERIOD 1",
  "PERIOD 2",
  "PERIOD 3",
  "PERIOD 4"
];

final List<String> period5Names = [
  "PERIOD 5 (1)",
  "PERIOD 5 (2)",
  "PERIOD 5 (3)",
  "PERIOD 5 (4)"
];

enum MenuChoices { refresh, settings }

double textSize;
double deviceWidth;
double padding;

void main() {
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "TDChristian InfoBoard",
        home: InfoBoard(),
        theme: ThemeData(
          primaryColor: Colors.green,
        ));
  }
}

class InfoBoard extends StatefulWidget {
  InfoBoard({Key key}) : super(key: key);

  @override
  _InfoBoardState createState() => _InfoBoardState();
}

class _InfoBoardState extends State<InfoBoard> {
  @override
  void initState() {
    super.initState();
    _getUserData();
    _getInfoBoard();
  }

  _getInfoBoard() async {
    final String url =
        'http://splash.tdchristian.ca/apps/if2/getScreenData.php';
    HttpClient httpClient = HttpClient();

    String topMessage;
    String bottomMessage;
    String image1Url;
    String image2Url;
    List<Period> periods;

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        failedToGetInfoBoard = false;
        var jsonData = await response.transform(utf8.decoder).join();
        var data = json.decode(jsonData);
        topMessage = data['5'][1];
        bottomMessage = data['6'][1];
        image1Url = data['7'];
        image2Url = data['8'];
        periods = getPeriods(data['4']);
      } else {
        failedToGetInfoBoard = true;
      }
    } catch (exception) {
      failedToGetInfoBoard = true;
      print(exception);
    }

    attemptedGetInfoBoard = true;
    if (!mounted) return;

    setState(() {
      _topMessage = topMessage;
      _bottomMessage = bottomMessage;
      _periods = periods;
      _image1Url = image1Url;
      _image2Url = image2Url;
    });
  }

  List<Period> getPeriods(List<dynamic> periodsList) {
    List<Period> periods = [];

    if (periodsList == null) {
      return periods;
    }

    if (periodsList.length > 0) {
      for (var p in periodsList) {
        periods.add(Period(p[0], p[1], p[2]));
      }
    }
    return periods;
  }

  _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    grade9Mode = prefs.getBool('grade9Mode') ?? false;
    hideTopMessage = prefs.getBool('hideTopMessage') ?? false;
    enableCustomPeriodNames = prefs.getBool('enableCustomPeriodNames') ?? false;
    customPeriodNames = prefs.getStringList('customPeriodNames') ??
        ["PERIOD 1", "PERIOD 2", "PERIOD 3", "PERIOD 4"];

    customPeriodNamesDay2 = prefs.getStringList('customPeriodNamesDay2') ??
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
    MediaQueryData queryData = MediaQuery.of(context);
    deviceWidth = queryData.size.width * queryData.devicePixelRatio;
    textSize = 19.0 + ((deviceWidth - 700) / 180).roundToDouble();

    _bottomMessage = _bottomMessage == "" ? "NO MESSAGE" : _bottomMessage;

    _bottomMessage = _bottomMessage == null
        ? _bottomMessage
        : _bottomMessage.replaceAll('<BR>', '\n');

    _saveValues();

    isSchoolToday = true;

    if (_topMessage != null) {
      if (_topMessage.contains("TODAY")) {
        isSchoolToday = true;
      }
    }

    List<Widget> menuChoices = [
      PopupMenuButton<MenuChoices>(
          onSelected: (MenuChoices result) {
            setState(() {
              if (result == MenuChoices.refresh) {
                _getInfoBoard();
              } else if (result == MenuChoices.settings) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              }
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuChoices>>[
                PopupMenuItem<MenuChoices>(
                  value: MenuChoices.refresh,
                  child: ListTile(
                    leading: Icon(Icons.refresh),
                    title: Text('REFRESH'),
                  ),
                ),
                PopupMenuItem<MenuChoices>(
                    value: MenuChoices.settings,
                    child: ListTile(
                        leading: Icon(Icons.settings), title: Text("SETTINGS")))
              ])
    ];

    if (_periods == null || _periods.isEmpty) {
      isSchoolToday = false;
    }

    AppBar appBar = AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFFFFF),
        title: Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Text(
            hideTopMessage || !isSchoolToday ? "" : _topMessage,
            style: TextStyle(
                fontFamily: "RobotoCondensed",
                fontSize: 24.0,
                fontWeight: FontWeight.w600),
          ),
        ),
        actions: menuChoices);

    if (isSchoolToday) {
      Image image1;
      Image image2;

      try {
        image1 = Image.network(
          _image1Url != ""
              ? graphicsBaseUrl + _image1Url
              : "http://splash.tdchristian.ca/apps/infoboard/graphics//HappyFace.gif",
          fit: BoxFit.contain,
        );
        image2 = Image.network(_image2Url != ""
            ? graphicsBaseUrl + _image2Url
            : "http://splash.tdchristian.ca/apps/infoboard/graphics//HappyFace.gif");
      } catch (exception) {
        print(exception);
      }

      padding = deviceWidth < 1200 ? 24.0 : 32.0;

      _launchPage(String url) async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }

      return Stack(children: [
        Scaffold(
            appBar: hideTopMessage ? null : appBar,
            backgroundColor: Colors.green,
            body: Column(
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: padding,
                            right: padding,
                            bottom: padding - 16.0),
                        child: Column(children: [
                          hideTopMessage ? SizedBox(height: 56.0) : Container(),
                          Expanded(
                              flex: 4,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: _periods
                                      .map((period) => PeriodWidget(period))
                                      .toList())),
                          Container(height: 12.0),
                          Expanded(
                              flex: 2,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Flexible(
                                        flex: 2,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(right: padding),
                                          child: Column(
                                            children: <Widget>[image1, image2],
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                          ),
                                        )),
                                    Flexible(
                                        flex: 5,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.green[700],
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30.0))),
                                            child: Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Center(
                                                    child: AutoSizeText(
                                                  _bottomMessage,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "RobotoCondensed",
                                                      fontSize: textSize - 4,
                                                      color: Colors.white),
                                                ))))),
                                  ])),
                        ]))),
                Expanded(
                    flex: 1,
                    child: Container(
                        color: Colors.green[700],
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: padding,
                                right: padding,
                                top: 8.0,
                                bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: FlatButton(
                                    onPressed: () {
                                      _launchPage(
                                          "https://tdchristian.edsby.com/p/BasePublic/");
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                            child: Image.asset(
                                                'assets/edsby.png')),
                                        Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'EDSBY',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "RobotoCondensed",
                                                  fontSize: textSize - 6.0,
                                                  color: Colors.white),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                    fit: FlexFit.tight,
                                    child: FlatButton(
                                      onPressed: () {
                                        _launchPage(
                                            "https://splash.tdchristian.ca/");
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                              child: Image.asset(
                                                  'assets/splash.png')),
                                          Text(
                                            'SPLASH!',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "RobotoCondensed",
                                                fontSize: textSize - 6.0,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    )),
                                Flexible(
                                  fit: FlexFit.tight,
                                  child: FlatButton(
                                    onPressed: () {
                                      _launchPage(
                                          "https://tdch.mybusplanner.ca/StudentLogin.aspx");
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Image.asset(
                                                    'assets/bus.png'))),
                                        Padding(
                                            padding: EdgeInsets.only(top: 0.0),
                                            child: AutoSizeText(
                                              'BUS TRACKER',
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "RobotoCondensed",
                                                  fontSize: textSize - 6.0,
                                                  color: Colors.white),
                                            ))
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ))))
              ],
            )),
        hideTopMessage
            ? Scaffold(
                backgroundColor: Color(0xFFFFFF),
                appBar: AppBar(
                    backgroundColor: Color(0xFFFFFF),
                    elevation: 0.0,
                    actions: menuChoices),
              )
            : Container()
      ]);
    } else if (failedToGetInfoBoard && attemptedGetInfoBoard) {
      return Scaffold(
          appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.green,
              actions: menuChoices),
          backgroundColor: Colors.green,
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('!',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "RobotoCondensed",
                      fontSize: 250.0,
                      color: Colors.white)),
              Text('FAILED TO LOAD INFOBOARD',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "RobotoCondensed",
                      fontSize: 24.0,
                      color: Colors.white)),
              Text('PLEASE CHECK YOUR INTERNET CONNECTION',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: "RobotoCondensed",
                      fontSize: 18.0,
                      color: Colors.white))
            ],
          )));
    } else if (!isSchoolToday && attemptedGetInfoBoard) {
      return Scaffold(
          appBar: appBar,
          backgroundColor: Colors.green,
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: AssetImage('assets/happyface.png'),
                height: 200.0,
              ),
              Text('NOTHING TO SHOW HERE',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "RobotoCondensed",
                      fontSize: 36.0,
                      color: Colors.white))
            ],
          )));
    } else {
      return Scaffold(backgroundColor: Colors.green);
    }
  }
}

class PeriodWidget extends StatelessWidget {
  final Period _period;
  PeriodWidget(this._period);

  String change24HourTo12Hour(String time24) {
    int colonIndex = time24.indexOf(':');
    int hour = int.parse(time24.substring(0, colonIndex));
    int minute = int.parse(time24.substring(colonIndex + 1));

    var now = DateTime.now();
    var dateTime = DateTime(now.year, now.month, now.day, hour, minute);

    if (lastChecked != null) {
      if (lastChecked.isBefore(now)) {
        if (now.isBefore(dateTime)) {
          currentPeriod = this;
        }
      }
    }

    lastChecked = dateTime;

    var formatter = DateFormat('K:m');
    String time12 = formatter.format(dateTime);

    if (minute < 10) {
      colonIndex = time12.indexOf(":");
      String minuteString = "0" + minute.toString();
      time12 = time12.replaceRange(colonIndex + 1, time12.length, minuteString);
    }
    if (hour == 12 || hour == 0) {
      return time12.replaceFirst('0', '12');
    } else {
      return time12;
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = _period.name;

    if (enableCustomPeriodNames) {
      if (grade9Mode && _topMessage.contains("DAY 2")) {
        for (int i = 0; i < periodNames.length; i++) {
          if (_period.name.contains(periodNames[i]) ||
              _period.name.contains(period5Names[i])) {
            name = customPeriodNamesDay2[i];
          }
        }
      } else {
        for (int i = 0; i < periodNames.length; i++) {
          if (_period.name.contains(periodNames[i]) ||
              _period.name.contains(period5Names[i])) {
            name = customPeriodNames[i];
          }
        }
      }
    }

    String startTime = change24HourTo12Hour(_period.startTime) +
        " - " +
        change24HourTo12Hour(_period.endTime);

    return Expanded(
        child: Material(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "RobotoCondensed",
                fontSize: textSize,
                color: Colors.white),
            child: Container(
                decoration: BoxDecoration(
                    color: currentPeriod == this ? Colors.green[700] : null,
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          name.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        child: Text(
                          startTime,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ]))));
  }
}
