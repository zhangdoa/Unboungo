import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/WidgetBuilders.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

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
        child: _isLoadedMap ? _buildMapWidget() : _buildInitialPage());
  }

  Column _buildInitialPage() {
    return Column(
      children: <Widget>[
        buildCenterLogo('MAP', 20.0, Icons.map, Colors.redAccent),
        Divider(
          height: 24.0,
        ),
        buildRoundButton('Open Map', Colors.redAccent, _prepareMap),
      ],
    );
  }

  Future<bool> _prepareMap() async {
    setState(() {
      _isLoadedMap = true;
    });
    return true;
  }

  Widget _buildMapWidget() {
    return new Column(children: <Widget>[
      new Flexible(
          child: FlutterMap(
        options: new MapOptions(
          center: new LatLng(0.0, 0.0),
          zoom: 18.0,
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 80.0,
                height: 80.0,
                point: new LatLng(51.5, -0.09),
                builder: (ctx) => new Container(
                      child: new FlutterLogo(),
                    ),
              ),
            ],
          ),
        ],
      ))
    ]);
  }

  bool _isLoadedMap = false;
}
