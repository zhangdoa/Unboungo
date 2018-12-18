import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';

import 'package:unboungo/MainScreen.dart';
import 'package:unboungo/Interactor.dart';
import 'package:unboungo/Presenter.dart';
import 'package:unboungo/Model.dart';

import 'package:unboungo/Theme.dart';

class SettingPage extends StatefulWidget {
  @override
  State createState() => new SettingPageState();
}

class SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          children: <Widget>[
            buildCenterLogo(),
            buildLabel('Device info'),
            _isDeviceInfosAcquired
                ? buildDeviceInfoListView()
                : Text('Please press the button to get device info',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                    )),
            buildRoundButton(
                'Get Device info', Colors.redAccent, getDeviceInfos),
          ],
        ));
  }

  Widget buildDeviceInfoListView() {
    return new Flexible(
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(40.0, 40.0, 0.0, 0.0),
          reverse: true,
          itemBuilder: (_, int index) => _deviceInfoWidgets[index],
          itemCount: _deviceInfoWidgets.length,
        ),
    );
  }

  Widget buildCenterLogo() {
    return Container(
      padding: EdgeInsets.all(100.0),
      child: Center(
        child: Column(children: <Widget>[
          Icon(
            Icons.device_hub,
            color: Colors.redAccent,
            size: 50.0,
          ),
          Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.0,
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildLabel(text) {
    return new Row(
      children: <Widget>[
        Expanded(
          child: new Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: new Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRoundButton(text, color, onPressedCallback) {
    return FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        onPressed: onPressedCallback,
        child: Text(
          text,
          style: TextStyle(fontSize: 16.0),
        ),
        color: color,
        highlightColor: Color(0xffff7f7ff),
        splashColor: Colors.transparent,
        textColor: Colors.white,
        padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0));
  }

  void getDeviceInfos() async {
    _deviceInfos = await UbUtilities().getAndroidDeviceInfo();
    setState(() {
      _deviceInfoWidgets.clear();
    });
    for (var value in _deviceInfos) {
      _buildDeviceInfoWidgets(value);
    }
    setState(() {
      _isDeviceInfosAcquired = true;
    });
  }

  void _buildDeviceInfoWidgets(String text) {
    DeviceInfoWidget deviceInfoWidget = new DeviceInfoWidget(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    setState(() {
      _deviceInfoWidgets.insert(0, deviceInfoWidget);
    });
    deviceInfoWidget.animationController.forward();
  }

  bool _isDeviceInfosAcquired = false;
  final List<DeviceInfoWidget> _deviceInfoWidgets = <DeviceInfoWidget>[];
  List<String> _deviceInfos;
}

class DeviceInfoWidget extends StatelessWidget {
  DeviceInfoWidget({this.text, this.animationController});

  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.0,
      ),
    );
  }
}
