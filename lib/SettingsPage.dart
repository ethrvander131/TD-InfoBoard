import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

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
<<<<<<< HEAD

        appBar: new AppBar(
          title: new Text('Settings'),
          elevation: 0.0,
        ),
        body: new ListView(
          children: <Widget>[
            new SizedBox(height: 8.0),
            new ListTile(
              dense: true,
              title: new Text("Support the developer!"),
              subtitle: new Padding(
                padding: new EdgeInsets.only(top: 3.0),
                child: new Text(
                  "Open a webpage to donate"
                )
              ),
              onTap: _launchDonatePage,
            ),
            divider,
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
        ));
=======
      appBar: new AppBar(
        title: new Text('Settings'),
        elevation: 0.0,
      ),
      body: new ListView(
        children: <Widget>[
          new SizedBox(height: 8.0),
          new ListTile(
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
>>>>>>> parent of 19f805f... Data is now persistent, Grade 9 Mode works, cleaned up code
  }
}
