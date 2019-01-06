import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/WidgetBuilders.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:unboungo/Presenter.dart';
import 'package:unboungo/Theme.dart';

class MapScreen extends StatefulWidget {
  @override
  State createState() => new MapScreenState();
}

class MapScreenState extends State<MapScreen> implements PagePresenter {
  @override
  Widget build(BuildContext context) {
    return buildWidget();
  }

  @override
  Widget buildWidget() {
    return MaterialApp(
        title: "MapScreen",
        theme: kDefaultTheme,
        home: Scaffold(
            key: _scaffoldKey,
            body: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child:
                    _isLoadedMap ? _buildMapWidget() : _buildInitialPage())));
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
    return Column(children: <Widget>[
      Flexible(
          child: FlutterMap(
        options: MapOptions(
          center: london,
          zoom: 1.0,
        ),
        layers: [
          TileLayerOptions(urlTemplate: _url5, subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(
            markers: [
              Marker(
                  width: 30.0,
                  height: 30.0,
                  point: LatLng(0.0, 0.0),
                  builder: (ctx) => Container(
                      child: new GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                              content: new Text("Tapped"),
                            ));
                          },
                          child: new FlutterLogo(colors: Colors.red)))),
            ],
          ),
        ],
      )),
      buildLabel('Map', Colors.redAccent)
    ]);
  }

  bool _isLoadedMap = false;
  String _url1 = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}';
  String _url2 =
      'https://server.arcgisonline.com/ArcGIS/rest/services/Specialty/DeLorme_World_Base_Map/MapServer/tile/{z}/{y}/{x}';
  String _url3 =
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}';
  String _url4 =
      'https://server.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}';
  String _url5 =
      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

  static LatLng london = new LatLng(51.5, -0.09);
  static LatLng paris = new LatLng(48.8566, 2.3522);
  static LatLng dublin = new LatLng(53.3498, -6.2603);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
}
