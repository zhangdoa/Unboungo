import 'package:flutter/material.dart';

import 'package:unboungo/WidgetBuilders.dart';

import 'package:unboungo/Theme.dart';

class AboutPage extends StatefulWidget {
  @override
  State createState() => new AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: getThemeData().backgroundColor,
        ),
        child: Column(
          children: <Widget>[
            buildCenterLogo(
            'ABOUT', 20.0, Icons.adb, getThemeData().accentColor),
            Divider(height: 12.0),
            Text(
              "Copyright (c) 2019 zhangdoa",
              style: new TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                letterSpacing: 1.0,
              ),
              textAlign: TextAlign.center,
            )
          ]
        )
    );
  }
}
