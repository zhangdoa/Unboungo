import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/Theme.dart';

class LogInScreen extends StatefulWidget {
  @override
  State createState() => new LogInScreenState();
}

class LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "Unboungo",
        theme: kDefaultTheme,
        home: Scaffold(
            appBar: AppBar(
              title: Text('Unboungo'),
            ),
            body: Text('LogInPage')));
  }
}
