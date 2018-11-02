import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

TextStyle _textStyle = TextStyle(
    color: Colors.white,
    fontFamily: "RobotoCondensed",
    fontWeight: FontWeight.w500,
    fontSize: 18.0);

TextStyle _subtitleTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: "RobotoCondensed",
    fontWeight: FontWeight.w400,
    fontSize: 15.0);

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
            style: TextStyle(
                fontFamily: "RobotoCondensed", fontWeight: FontWeight.w600),
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
                  borderSide:
                      BorderSide(color: Colors.white, style: BorderStyle.solid),
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
                  borderSide:
                      BorderSide(color: Colors.white, style: BorderStyle.solid),
                ),
              ),
              onChanged: (String input) {
                customPeriodNamesDay2[i] = input == "" ? periodNames[i] : input;
              },
            ),
          )
        ],
      ));
    }
  }

  return Column(children: periodFields);
}
