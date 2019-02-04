import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:unboungo/Theme.dart';

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

  Container buildRowElementPadder(context, margin, width) {
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

  Widget buildNormalText(context, text, textColor) {
    return new Text(
      text,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: textColor,
        fontSize: 15.0,
      ),
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

  Widget buildWarningText(context, text) {
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
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.left,
                ))),
      ],
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

  Container buildInputFieldContainer(context, hintText, textController, onTap,
      onSubmitted, onChanged, obscureText) {
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
      child: buildInputRow(
          hintText, textController, onTap, onSubmitted, onChanged, obscureText),
    );
  }

  Widget buildInputRow(
      hintText, textController, onTap, onSubmitted, onChanged, obscureText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Expanded(
          child: TextField(
            controller: textController,
            onTap: onTap,
            onSubmitted: onSubmitted,
            onChanged: onChanged,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: TextStyle(color: Colors.white),
            obscureText: obscureText,
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

  Widget buildDropdownButton(context, List<String> items, onChanged,
      hint, textColor, fontSize) {
    return new DropdownButton<String>(
        hint: new Text(hint,
            style: new TextStyle(
              color: Colors.white,
              fontSize: fontSize * _getDevicePixelRatio(context),
            )),
        items: items.map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value,
                style: new TextStyle(
                  color: textColor,
                  fontSize: fontSize * _getDevicePixelRatio(context),
                )),
          );
        }).toList(),
        onChanged: onChanged);
  }

  Widget buildQRImage(context, text, size, foregroundColor) {
    return new QrImage(
        data: text,
        size: size * _getDevicePixelRatio(context),
        foregroundColor: foregroundColor);
  }

  Widget buildLoadingCircularProgressIndicator(color) {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color));
  }

  Widget buildUserAvatar(context, userName) {
    return Container(
      margin: EdgeInsets.fromLTRB(4.0 / _getDevicePixelRatio(context),
          4.0 / _getDevicePixelRatio(context), 0.0, 0.0),
      child: CircleAvatar(
          child: Text(userName),
          backgroundColor: getThemeData().buttonColor,
          foregroundColor: getThemeData().accentColor),
    );
  }

  Widget buildFriendButton(context, name, nameColor, onPressedCallback) {
    return new Container(
        decoration: ShapeDecoration(
            color: getThemeData().canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0),
            )),
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(40.0 * _getDevicePixelRatio(context), 0.0,
            40.0 * _getDevicePixelRatio(context), 0.0),
        child: FlatButton(
            onPressed: () {
              onPressedCallback(name);
            },
            child: Row(children: <Widget>[
              buildUserAvatar(context, name[0]),
              buildRowElementPadder(context, 4.0, 0.25),
              buildNormalText(context, name, nameColor)
            ]),
            padding: EdgeInsets.fromLTRB(
                5.0 * _getDevicePixelRatio(context),
                5.0 * _getDevicePixelRatio(context),
                5.0 * _getDevicePixelRatio(context),
                5.0 * _getDevicePixelRatio(context))));
  }

  Widget buildRecentChatButton(
      context, name, nameColor, message, onPressedCallback) {
    return new Container(
        decoration: ShapeDecoration(
            color: getThemeData().canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0),
            )),
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(
            40.0 * _getDevicePixelRatio(context),
            10.0 * _getDevicePixelRatio(context),
            40.0 * _getDevicePixelRatio(context),
            10.0 * _getDevicePixelRatio(context)),
        child: FlatButton(
            onPressed: () {
              onPressedCallback(name);
            },
            child: Row(children: <Widget>[
              buildUserAvatar(context, name[0]),
              buildRowElementPadder(context, 4.0, 0.25),
              Flexible(
                  child: Column(children: <Widget>[
                Row(children: <Widget>[
                  buildNormalText(context, name, nameColor)
                ]),
                buildNormalText(context, message, Colors.white)
              ])),
            ]),
            padding: EdgeInsets.fromLTRB(
                5.0 * _getDevicePixelRatio(context),
                5.0 * _getDevicePixelRatio(context),
                5.0 * _getDevicePixelRatio(context),
                5.0 * _getDevicePixelRatio(context))));
  }
}
