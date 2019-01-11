import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class UBWidgetBuilder {
  static final UBWidgetBuilder _singleton = new UBWidgetBuilder._internal();

  factory UBWidgetBuilder() {
    return _singleton;
  }

  UBWidgetBuilder._internal();

  double _getDevicePixelRatio(context) {
    var mediaQueryData = MediaQuery.of(context);
    //var factor = 2880.0 / mediaQueryData.size.height;
    var w = mediaQueryData.size.width / 2880.0;
    var h = mediaQueryData.size.height / 1440.0;
    var factor = mediaQueryData.devicePixelRatio * w / h;
    return factor;
  }

  Widget buildDivider(context, height) {
    return Divider(height: height * _getDevicePixelRatio(context));
  }

  Widget buildRoundButton(context, text, textColor, onPressedCallback) {
    return new FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        onPressed: onPressedCallback,
        child: new Text(
          text,
          style: new TextStyle(fontSize: 16.0),
        ),
        color: textColor,
        highlightColor: Colors.white70,
        splashColor: Colors.transparent,
        textColor: Colors.white,
        padding: EdgeInsets.fromLTRB(
            30.0 * _getDevicePixelRatio(context),
            15.0 * _getDevicePixelRatio(context),
            30.0 * _getDevicePixelRatio(context),
            15.0 * _getDevicePixelRatio(context)));
  }

  Container buildRowButtonPadder(context, margin, width) {
    return Container(
      margin: EdgeInsets.all(margin * _getDevicePixelRatio(context)),
      decoration: BoxDecoration(
          border: Border.all(width: width * _getDevicePixelRatio(context))),
    );
  }

  Widget buildLabel(context, text, textColor) {
    return new Row(
      children: <Widget>[
        Expanded(
            child: new Padding(
                padding: EdgeInsets.fromLTRB(
                    40.0 * _getDevicePixelRatio(context),
                    0.0,
                    40.0 * _getDevicePixelRatio(context),
                    0.0),
                child: Text(
                  text,
                  style: new TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ))),
      ],
    );
  }

  Widget buildSplitText(context, text, textColor) {
    return new Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildAppBarText(context, text, textColor) {
    return new Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 18.0 * _getDevicePixelRatio(context),
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget buildCenterLogo(context, text, fontSize, icon, iconColor) {
    return new Container(
      padding: EdgeInsets.all(100.0 * _getDevicePixelRatio(context)),
      child: new Center(
        child: new Column(children: <Widget>[
          new Icon(
            icon,
            color: iconColor,
            size: 50.0,
          ),
          new Container(
            padding: EdgeInsets.all(10.0 * _getDevicePixelRatio(context)),
            child: Text(
              text,
              style: new TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                letterSpacing: 4.0 * _getDevicePixelRatio(context),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ]),
      ),
    );
  }

  Container buildInputFieldContainer(context, hintText, textController) {
    return new Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(40.0 * _getDevicePixelRatio(context), 0.0,
          40.0 * _getDevicePixelRatio(context), 0.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: Colors.redAccent, width: 1.0, style: BorderStyle.solid),
        ),
      ),
      child: buildInputRow(hintText, textController),
    );
  }

  Widget buildInputRow(hintText, textController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Expanded(
          child: TextField(
            controller: textController,
            obscureText: true,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPageEntryIconButton(
      context, text, fontSize, icon, iconColor, onPressed) {
    return new Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        padding: EdgeInsets.all(50.0 * _getDevicePixelRatio(context)),
        child: new Center(
          child: Column(children: <Widget>[
            new IconButton(
              icon: Icon(icon, size: 40.0),
              alignment: Alignment.center,
              color: iconColor,
              splashColor: Colors.white,
              onPressed: onPressed,
            ),
            Divider(
              height: 12.0 * _getDevicePixelRatio(context),
            ),
            new Text(
              text,
              style: new TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                letterSpacing: 4.0 * _getDevicePixelRatio(context),
              ),
              textAlign: TextAlign.center,
            )
          ]),
        ));
  }

  Widget buildDropdownButton(context, List<String> items, onChanged, fontSize) {
    return new DropdownButton<String>(
        items: items.map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value,
                style: new TextStyle(
                  color: Colors.black,
                  fontSize: fontSize * _getDevicePixelRatio(context),
                  letterSpacing: 2.0 * _getDevicePixelRatio(context),
                )),
          );
        }).toList(),
        onChanged: onChanged);
  }
}
