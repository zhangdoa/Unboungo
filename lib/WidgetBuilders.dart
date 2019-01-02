import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Widget buildRoundButton(text, textColor, onPressedCallback) {
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
      padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0));
}

Widget buildLabel(text, textColor) {
  return new Row(
    children: <Widget>[
      Expanded(
        child: new Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: new Text(
            text,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 15.0,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildCenterLogo(text, fontSize, icon, iconColor) {
  return new Container(
    padding: EdgeInsets.all(100.0),
    child: new Center(
      child: new Column(children: <Widget>[
        new Icon(
          icon,
          color: iconColor,
          size: 50.0,
        ),
        new Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            text,
            style: new TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              letterSpacing: 4.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    ),
  );
}

Container buildInputFieldContainer(hintText, textController) {
  return new Container(
    margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
            color: Colors.redAccent, width: 0.5, style: BorderStyle.solid),
      ),
    ),
    padding: const EdgeInsets.only(left: 0.0, right: 10.0),
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