import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';

import 'package:unboungo/WidgetBuilders.dart';
import 'package:unboungo/Presenter.dart';
import 'package:unboungo/Theme.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget buildWidget() {
    return MaterialApp(
        title: "MapScreen",
        theme: getThemeData(),
        home: Scaffold(
            appBar: AppBar(actions: <Widget>[
              Row(children: <Widget>[
                UBWidgetBuilder().buildAppBarText(context, "Map provider", getThemeData().backgroundColor),
                UBWidgetBuilder().buildDropdownButton(context,
                    _mapProvider.keys.toList(), onMapProviderChanged, 16.0)
              ])
            ]),
            key: _scaffoldKey,
            body: Container(
                decoration: BoxDecoration(
                  color: getThemeData().backgroundColor,
                ),
                child:
                    _isLoadedMap ? _buildMapWidget() : _buildInitialPage())));
  }

  Column _buildInitialPage() {
    return Column(
      children: <Widget>[
        UBWidgetBuilder().buildCenterLogo(
            context, 'MAP', 20.0, Icons.map, getThemeData().accentColor),
        Divider(
          height: 24.0,
        ),
        UBWidgetBuilder().buildRoundButton(
            context, 'Open Map', getThemeData().accentColor, _prepareMap),
      ],
    );
  }

  Future<bool> _prepareMap() async {
    await _getLatestLocation();
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
          center: LatLng(_pos.latitude, _pos.longitude),
          zoom: 1.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: _mapProvider[_currentMapProvider],
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(
            markers: [
              Marker(
                  width: 40.0,
                  height: 40.0,
                  point: LatLng(_pos.latitude, _pos.longitude),
                  builder: (ctx) => Container(
                      child: new GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState.showSnackBar(new SnackBar(
                              content: new Text("I am here in (" +
                                  _pos.latitude.toString() +
                                  ", " +
                                  _pos.longitude.toString() +
                                  ")!"),
                            ));
                          },
                          child: new FlutterLogo(colors: Colors.red)))),
            ],
          ),
        ],
      )),
      UBWidgetBuilder().buildLabel(
          context,
          "Using map data from: " + _currentMapProvider,
          getThemeData().accentColor)
    ]);
  }

  void onMapProviderChanged(newProvider) {
    setState(() {
      _currentMapProvider = newProvider;
    });
  }

  void _getLatestLocation() async {
    _pos = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {});
  }

  bool _isLoadedMap = false;

  static var _mapProvider = {
    'OpenStreetMap.Mapnik': 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}',
    'Esri.DeLorme':
        'https://server.arcgisonline.com/ArcGIS/rest/services/Specialty/DeLorme_World_Base_Map/MapServer/tile/{z}/{y}/{x}',
    'Esri.WorldTopoMap':
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}',
    'Esri.NatGeoWorldMap':
        'https://server.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}',
    'Esri.WorldImagery':
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
  };

  static String _currentMapProvider = 'Esri.NatGeoWorldMap';
  static LatLng london = new LatLng(51.5, -0.09);
  static LatLng paris = new LatLng(48.8566, 2.3522);
  static LatLng dublin = new LatLng(53.3498, -6.2603);
  Position _pos;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
}
