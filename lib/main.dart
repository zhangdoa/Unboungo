import 'package:flutter/material.dart';

import 'package:unboungo/MainScreen.dart';
import 'package:unboungo/LogInScreen.dart';

void main() {
  runApp(new UnboungoApp());
}

class UnboungoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //return new MainScreen();
    return new LogInScreen();
  }
}

