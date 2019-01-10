import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/Model.dart';
import 'package:unboungo/WidgetBuilders.dart';
import 'package:unboungo/Presenter.dart';
import 'package:unboungo/Theme.dart';

class SettingScreen extends StatefulWidget {
  @override
  State createState() => new SettingScreenState();
}

class SettingScreenState extends State<SettingScreen>
    with TickerProviderStateMixin
    implements PagePresenter {
  @override
  Widget build(BuildContext context) {
    return buildWidget();
  }

  @override
  Widget buildWidget() {
    return new MaterialApp(
        title: "SettingScreen",
        theme: getThemeData(),
        home: Scaffold(
            body: Container(
                decoration: BoxDecoration(
                  color: getThemeData().backgroundColor,
                ),
                child: Column(
                  children: <Widget>[
                    buildCenterLogo('SETTINGS', 20.0, Icons.build,
                        getThemeData().accentColor),
                    buildLabel('Device info', getThemeData().accentColor),
                    Divider(height: 12.0),
                    _isDeviceInfosAcquired
                        ? buildDeviceInfoListView()
                        : Text('Please press the button to get device info',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                            )),
                    Divider(height: 12.0),
                    buildRoundButton('Get Device info',
                        getThemeData().accentColor, getDeviceInfos),
                  ],
                ))));
  }

  Widget buildDeviceInfoListView() {
    return new Flexible(
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        reverse: true,
        itemBuilder: (_, int index) => _deviceInfoWidgets[index],
        itemCount: _deviceInfoWidgets.length,
      ),
    );
  }

  void getDeviceInfos() async {
    _deviceInfos = await UbUtilities().getAndroidDeviceInfo();
    setState(() {
      _deviceInfoWidgets.clear();
    });
    _deviceInfos.forEach(
        (String type, String text) => _buildDeviceInfoWidgets(type, text));
    setState(() {
      _isDeviceInfosAcquired = true;
    });
  }

  void _buildDeviceInfoWidgets(String type, String text) {
    DeviceInfoWidget deviceInfoWidget = new DeviceInfoWidget(
      type: type,
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
  Map<String, String> _deviceInfos;
}

class DeviceInfoWidget extends StatelessWidget {
  DeviceInfoWidget({this.type, this.text, this.animationController});

  final String type;
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Text(type,
            style: TextStyle(
              color: getThemeData().accentColor,
              fontSize: 15.0,
            ),
            textAlign: TextAlign.center),
        Container(
          child: Text(text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
              textAlign: TextAlign.center),
          padding: const EdgeInsets.all(2.0),
        ),
        Divider(
          height: 12.0,
        )
      ],
    );
  }
}
