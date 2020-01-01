import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets.dart';

bool grade9Mode = false;
bool hideTopMessage = false;
bool enableCustomPeriodNames = true;
bool isSchoolToday = false;
bool isAssembly = false;
bool failedToGetInfoBoard = true;
bool attemptedGetInfoBoard = false;

PeriodWidget currentPeriod;

DateTime lastChecked;

String centerMessage = "";
String topMessage = "TOP MESSAGE";
String bottomMessage = "BOTTOM MESSAGE";
String image1Url = "";
String image2Url = "";
final String graphicsBaseUrl = "http://splash.tdchristian.ca/apps/infoboard/";

List<String> customPeriodNames;
List<String> customPeriodNamesDay2;
List<Period> periods = [];

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
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.green[700],
      systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomePage(),
        theme: ThemeData(
            primaryColor: Colors.green,
            hintColor: Colors.black12,
            dividerColor: Colors.black12,
            fontFamily: "RobotoCondensed"));
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

    String topMessageData;
    String bottomMessageData;
    String image1UrlData;
    String image2UrlData;
    List<Period> periodsData;
    String centerMessageData;

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        failedToGetInfoBoard = false;
/*
        String jsonData = await DefaultAssetBundle.of(context)
            .loadString("assets/test-data.json");

        */
        String jsonData = await response.transform(utf8.decoder).join();
        var data = json.decode(jsonData);
        centerMessageData = data['3'];
        periodsData = getPeriods(data['4']);
        topMessageData = data['5'][1];
        bottomMessageData = data['6'][1];
        image1UrlData = data['7'];
        image2UrlData = data['8'];
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
      centerMessage = centerMessageData;
      topMessage = topMessageData;
      bottomMessage = bottomMessageData;
      periods = periodsData;
      image1Url = image1UrlData;
      image2Url = image2UrlData;
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

  List<Widget> _getMenuChoices() {
    return [
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
  }

  _performChecks() {
    _saveValues();

    if (centerMessage != "") {
      isAssembly = true;
      return;
    }

    bottomMessage = bottomMessage == "" ? "NO MESSAGE" : bottomMessage;

    bottomMessage = bottomMessage == null
        ? bottomMessage
        : bottomMessage.replaceAll('<BR>', '\n');

    isSchoolToday = true;

    if (topMessage != null && topMessage.contains("TODAY")) {
      isSchoolToday = true;
    }

    if (periods == null || periods.isEmpty) {
      isSchoolToday = false;
    }
  }

  Widget _getInfoBoardScreen() {
    if (!attemptedGetInfoBoard) {
      return AwaitingInfoBoard();
    } else if (isAssembly) {
      return AssemblyInfoBoard();
    } else if (isSchoolToday) {
      return InfoBoard();
    } else if (failedToGetInfoBoard && attemptedGetInfoBoard) {
      return FailedInfoBoard();
    }
    return NoInfoBoard();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    deviceWidth = queryData.size.width * queryData.devicePixelRatio;

    padding = deviceWidth < 1200 ? 12.0 : 18.0;
    textSize = 19.0 + ((deviceWidth - 700) / 180).roundToDouble();

    _performChecks();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color(0xFFFFFF),
            title: Padding(
              padding: EdgeInsets.only(left: padding - 8.0),
              child: Text(
                hideTopMessage || !isSchoolToday ? "" : topMessage,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
              ),
            ),
            actions: _getMenuChoices()),
        backgroundColor: Colors.green,
        body: _getInfoBoardScreen()));
  }
}
