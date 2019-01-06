import 'package:flutter/material.dart';

import 'package:unboungo/WidgetBuilders.dart';

class AboutPage extends StatefulWidget {
  @override
  State createState() => new AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: buildCenterLogo(
            'ABOUT', 20.0, Icons.adb, Colors.redAccent));
  }
}
