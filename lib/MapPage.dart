import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/WidgetBuilders.dart';

class MapPage extends StatefulWidget {
  @override
  State createState() => new MapPageState();
}

class MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Column(children: <Widget>[
          buildCenterLogo('MAP', 20.0, Icons.map, Colors.redAccent),
        ]));
  }
}
