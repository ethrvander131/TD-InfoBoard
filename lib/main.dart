import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'period.dart';

String _topMessage = "TOP MESSAGE";
String _bottomMessage = "BOTTOM MESSAGE";
String _image1Url = "";
String _image2Url = "";
List<Period> _periods = [];

final String graphicsBaseUrl = "http://splash.tdchristian.ca/apps/infoboard/";

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new InfoBoard(),
    );
  }
}

class InfoBoard extends StatefulWidget {
  InfoBoard({Key key}) : super(key: key);

  @override
  _InfoBoardState createState() => new _InfoBoardState();
}

class _InfoBoardState extends State<InfoBoard> {

  _getInfoBoard() async {

    final String url = 'http://splash.tdchristian.ca/apps/if2/getScreenData.php';
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

    return new Container(
      child: new Scaffold(
        backgroundColor: Colors.green,
        body: new ListView(
          children: [
            new SizedBox(
              height: 20.0,
            ),
            new Container(
              margin: const EdgeInsets.all(10.0),
              child:  new Text(
                _topMessage,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: "RobotoCondensed",
                  fontSize: 24.0,
                  color: Colors.white
                )
              )
            ),
            new Column(
              children: _periods.map( (period) => new PeriodWidget(period)).toList(),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new Image.network(
                  _image1Url != "" ? graphicsBaseUrl + _image1Url : "http://splash.tdchristian.ca/apps/infoboard/graphics//HappyFace.gif",
                  height: 100.0,
                ),
                new Image.network(
                  _image2Url != "" ? graphicsBaseUrl + _image2Url : "http://splash.tdchristian.ca/apps/infoboard/graphics//HappyFace.gif",
                  height: 100.0
                ),
              ],
            ),
            new Padding(
              padding: const EdgeInsets.all(12.0),
              child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: new BorderRadius.all(new Radius.circular(12.0))
                ),
                child: new Center(
                  heightFactor: 5.0,
                  child: new Text(
                    _bottomMessage,
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                      fontFamily: "RobotoCondensed",
                      fontSize: 22.0,
                      color: Colors.white
                    )
                  )
                ),
              ),
            ),
          ]
        ),
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.green,
          child: new Icon(Icons.refresh),
          onPressed: _getInfoBoard,
        ),
      )
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
    } else { return time12; }
  }

  @override
  Widget build(BuildContext context) {

    return new Padding(
      padding: new EdgeInsets.all(12.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Text(
              _period.name,
              style: new TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "RobotoCondensed",
                fontSize: 24.0,
                color: Colors.white
              ),
              textAlign: TextAlign.center
              ),
          new Text(
            change24HourTo12Hour(_period.startTime) + " - " + change24HourTo12Hour(_period.endTime),
              style: new TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "RobotoCondensed",
                fontSize: 24.0,
                color: Colors.white
              ),
              textAlign: TextAlign.center),
        ]
      )
    );
  }
}

List<Period> getPeriods(List<List<String>> periodsList) {
  List<Period> periods = [];

  if (periodsList.length > 0) {
    for (var p in periodsList) {
      // DateTime startTime = DateTime.parse(p[1]);
      periods.add(new Period(p[0], p[1], p[2]));
    }
  }
  
  return periods;

}