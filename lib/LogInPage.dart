import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:unboungo/MainScreen.dart';

import 'package:unboungo/Model.dart';

import 'package:unboungo/Theme.dart';

class LogInPage extends StatefulWidget {
  @override
  State createState() => new LogInPageState();
}

class LogInPageState extends State<LogInPage> {
  final googleSignIn = new GoogleSignIn();
  final analytics = new FirebaseAnalytics();
  final auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children:<Widget>[
        Center(
          child: FlatButton(
              onPressed: () async { await signInWithGoogle();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
              );},
              child: Text(
                'Sign in with Google',
                style: TextStyle(fontSize: 16.0),
              ),
              color: Color(0xffdd4b39),
              highlightColor: Color(0xffff7f7f),
              splashColor: Colors.transparent,
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
        ),
        Positioned(
          child: isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(
                  valueColor:
                  AlwaysStoppedAnimation<Color>(kDefaultTheme.accentColor)),
            ),
            color: Colors.white.withOpacity(0.8),
          )
              : Container(),
        )
        ]
    );
  }

  Future<bool> signInWithGoogle() async {
    this.setState(() {
      isLoading = true;
    });

    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final FirebaseUser user = await auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);

    UserData.fullName = user.displayName;
    UserData.email = user.email;

    this.setState(() {
      isLoading = false;
    });

    return true;
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });
  }
}