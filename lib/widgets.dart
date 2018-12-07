import 'package:auto_size_text/auto_size_text.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

TextStyle _textStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18.0);

TextStyle _subtitleTextStyle =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 15.0);

class InfoBoard extends StatelessWidget {
  _launchPage(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            flex: 6,
            child: Column(children: [
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: periods
                            .map((period) => PeriodWidget(period))
                            .toList()),
                  )),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: padding, right: padding),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(right: padding),
                                child: Column(
                                  children: <Widget>[
                                    FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: image1Url != ""
                                            ? graphicsBaseUrl + image1Url
                                            : "http://splash.tdchristian.ca/apps/infoboard/graphics//HappyFace.gif"),
                                    FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: image2Url != ""
                                            ? graphicsBaseUrl + image2Url
                                            : "http://splash.tdchristian.ca/apps/infoboard/graphics//HappyFace.gif")
                                  ],
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
                                        bottomMessage,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: textSize - 4,
                                            color: Colors.white),
                                      ))))),
                        ]),
                  )),
            ])),
        LinkBar()
      ],
    );
  }
}

class FailedInfoBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('!',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 250.0,
                color: Colors.white)),
        Text('FAILED TO LOAD INFOBOARD',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24.0,
                color: Colors.white)),
        Text('PLEASE CHECK YOUR INTERNET CONNECTION',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
                color: Colors.white))
      ],
    ));
  }
}

class NoInfoBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        flex: 6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image(
              image: AssetImage('assets/happyface.png'),
              height: 200.0,
            ),
            Text('NOTHING TO SHOW HERE',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 36.0,
                    color: Colors.white)),
          ],
        ),
      ),
      LinkBar(),
    ]);
  }
}

class AwaitingInfoBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 5.0),
    );
  }
}

class AssemblyInfoBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 6,
          child: Center(
              child: AutoSizeText('ASSEMBLY THIS MORNING',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 48.0,
                      color: Colors.white))),
        ),
        LinkBar()
      ],
    );
  }
}

class LinkBar extends StatelessWidget {
  _launchPage(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: padding),
        child: Container(
            color: Colors.green[700],
            child: Padding(
                padding: EdgeInsets.only(
                    left: padding, right: padding, top: 8.0, bottom: 8.0),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(child: Image.asset('assets/edsby.png')),
                            Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'EDSBY',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
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
                            _launchPage("https://splash.tdchristian.ca/");
                          },
                          child: Column(
                            children: <Widget>[
                              Expanded(child: Image.asset('assets/splash.png')),
                              Text(
                                'SPLASH!',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Image.asset('assets/bus.png')),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 0.0),
                                child: AutoSizeText(
                                  'BUS TRACKER',
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: textSize - 6.0,
                                      color: Colors.white),
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ))),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Widget getCustomPeriodsFields() {
    List<Widget> periodFields = [];

    if (enableCustomPeriodNames) {
      for (int i = 0; i < periodNames.length; i++) {
        TextEditingController _controller =
            TextEditingController(text: customPeriodNames[i]);
        _controller.selection =
            TextSelection.collapsed(offset: _controller.value.text.length);
        periodFields.add(Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                periodNames[i],
                style: _textStyle,
                maxLines: 1,
              ),
            ),
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.characters,
                style: _subtitleTextStyle,
                cursorColor: Colors.white,
                controller: _controller,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white, style: BorderStyle.solid),
                  ),
                ),
                onChanged: (String input) {
                  customPeriodNames[i] = input == "" ? periodNames[i] : input;
                },
              ),
            )
          ],
        ));
      }
    }
    if (grade9Mode) {
      periodFields.insert(
          0,
          Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text("DAY 1",
                  style: TextStyle(fontSize: 16.0, color: Colors.white))));
      periodFields.add(SizedBox(
        height: 16.0,
      ));
      periodFields.add(Divider());
      periodFields.add(Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text("DAY 2",
              style: TextStyle(fontSize: 16.0, color: Colors.white))));

      for (int i = 0; i < periodNames.length; i++) {
        TextEditingController _controller =
            TextEditingController(text: customPeriodNamesDay2[i]);
        _controller.selection =
            TextSelection.collapsed(offset: _controller.value.text.length);
        periodFields.add(Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                periodNames[i],
                style: _textStyle,
                maxLines: 1,
              ),
            ),
            Expanded(
              child: TextField(
                textCapitalization: TextCapitalization.characters,
                style: _subtitleTextStyle,
                cursorColor: Colors.white,
                controller: _controller,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white, style: BorderStyle.solid),
                  ),
                ),
                onChanged: (String input) {
                  customPeriodNamesDay2[i] =
                      input == "" ? periodNames[i] : input;
                },
              ),
            )
          ],
        ));
      }
    }

    return Column(children: periodFields);
  }

  _launchDonatePage() async {
    const url = 'https://www.paypal.me/ethanvanderkooi';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Divider divider = new Divider();

    return new Scaffold(
        backgroundColor: Colors.green,
        appBar: new AppBar(
          title: new Text(
            'SETTINGS',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 0.0,
        ),
        body: new ListView(
          children: <Widget>[
            new SizedBox(height: 8.0),
            new ListTile(
              dense: true,
              title: new Text(
                "Hide top message",
                style: _textStyle,
              ),
              trailing: new Switch(
                value: hideTopMessage,
                onChanged: (bool newValue) {
                  setState(() {
                    hideTopMessage = newValue;
                  });
                },
                activeColor: Colors.white,
              ),
            ),
            divider,
            new ListTile(
              dense: true,
              title: new Text(
                "Enable custom period names",
                style: _textStyle,
              ),
              trailing: new Switch(
                value: enableCustomPeriodNames,
                onChanged: (bool newValue) {
                  setState(() {
                    enableCustomPeriodNames = newValue;
                  });
                },
                activeColor: Colors.white,
              ),
            ),
            divider,
            enableCustomPeriodNames
                ? new ListTile(
                    dense: true,
                    enabled: enableCustomPeriodNames,
                    title: new Text("Enable Grade 9 Mode", style: _textStyle),
                    subtitle: new Padding(
                        padding: new EdgeInsets.only(top: 3.0),
                        child: new Text(
                          "This will enable changing Day 1 & 2 classes",
                          style: _subtitleTextStyle,
                        )),
                    trailing: new Switch(
                      value: grade9Mode,
                      onChanged: (bool newValue) {
                        setState(() {
                          grade9Mode = newValue;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                  )
                : new Container(),
            enableCustomPeriodNames ? divider : new Container(),
            enableCustomPeriodNames
                ? getCustomPeriodsFields()
                : new Container(),
            enableCustomPeriodNames ? divider : new Container(),
            new ListTile(
              dense: true,
              title: new Text(
                "Support the developer!",
                style: _textStyle,
              ),
              subtitle: new Padding(
                  padding: new EdgeInsets.only(top: 3.0),
                  child: new Text(
                    "Open a webpage to donate",
                    style: _subtitleTextStyle,
                  )),
              onTap: _launchDonatePage,
            )
          ],
        ));
  }
}

class Period {
  String name;
  String startTime;
  String endTime;
  String customName;

  Period(String _name, String _startTime, String _endTime) {
    this.name = _name;
    this.startTime = _startTime;
    this.endTime = _endTime;
    this.customName = "";
  }

  printPeriod() {
    print('$name: $startTime - $endTime');
  }

  void setCustomName(String newName) {
    customName = newName;
  }

  String getCustomName() {
    return customName;
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
      if (grade9Mode && topMessage.contains("DAY 2")) {
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
            textStyle: TextStyle(
                fontFamily: "RobotoCondensed",
                fontWeight: FontWeight.w600,
                fontSize: textSize),
            child: Container(
                decoration: BoxDecoration(
                    color: currentPeriod == this ? Colors.green[700] : null,
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                child: Padding(
                  padding: EdgeInsets.only(left: padding, right: padding),
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
                      ]),
                ))));
  }
}
