
import 'package:flutter/material.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => new _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

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
            dense: true,
            title: new Text("Hide top message"),
            trailing: new Switch(
              value: hideTopMessage,
              onChanged: (bool newValue) {
                setState(() {
                  hideTopMessage = newValue;
                });
              },
              activeColor: Colors.green,
            ),
          ),
          
          divider,
          new ListTile(
            dense: true,
            title: new Text("Enable custom period names"),
            trailing: new Switch(
              value: enableCustomPeriodNames,
              onChanged: (bool newValue) {
                setState(() {
                  enableCustomPeriodNames = newValue;
                });
              },
              activeColor: Colors.green,
            ),
          ),
          divider,
          
          enableCustomPeriodNames
            ? new ListTile(
                dense: true,
                enabled: enableCustomPeriodNames,
                title: new Text("Enable Grade 9 Mode"),
                subtitle: new Padding(
                    padding: new EdgeInsets.only(top: 3.0),
                    child: new Text(
                        "This will enable changing Day 1 & 2 classes")),
                trailing: new Switch(
                  value: grade9Mode,
                  onChanged: (bool newValue) {
                    setState(() {
                      grade9Mode = newValue;
                    });
                  },
                  activeColor: Colors.green,
                ),
              )
            : new Container(),
          enableCustomPeriodNames ? divider : new Container(),
          enableCustomPeriodNames ? getCustomPeriodsFields() : new Container()
        ],
      )
    );
  }
}

