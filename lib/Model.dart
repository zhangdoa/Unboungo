import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class UserAccountInteractor {
  static final UserAccountInteractor _singleton = new UserAccountInteractor
      ._internal();
  static bool isLoading = false;
  static bool isLoggedIn = false;

  factory UserAccountInteractor() {
    return _singleton;
  }

  UserAccountInteractor._internal();

  Future<bool> signInWithGoogle() async {
    final googleSignIn = new GoogleSignIn();
    final analytics = new FirebaseAnalytics();
    final auth = FirebaseAuth.instance;

    isLoading = true;

    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;

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

    isLoading = false;

    return true;
  }

  Future<bool> signOut() async {
    final googleSignIn = new GoogleSignIn();
    final analytics = new FirebaseAnalytics();
    final auth = FirebaseAuth.instance;

    isLoading = true;

    await auth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    isLoading = false;

    return true;
  }

  void isSignedIn() async {
    isLoading = true;
  }
}

class UserData {
  static final UserData _singleton = new UserData._internal();
  static String fullName;
  static String email;

  factory UserData() {
    return _singleton;
  }

  UserData._internal();
}

class ChatMessage {
  final String fullName;
  final String messages;

  const ChatMessage({this.fullName, this.messages});

  ChatMessage.fromMap(Map<String, dynamic> map)
      :
        fullName = "${map['senderName']['first']} ${map['senderName']['last']}",
        messages = map['text'];
}

abstract class ChatMessageRepository {
  Future<List<ChatMessage>> fetch();

  Future<bool> send({ String text });
}

class FirebaseChatMessageRepository implements ChatMessageRepository {
  Future<List<ChatMessage>> fetch() async {
    final reference = FirebaseDatabase.instance.reference().child('messages');
    final List<ChatMessage> _messages = <ChatMessage>[];
    _messages.map((lambda) =>
    new ChatMessage.fromMap(reference.buildArguments()));
    return _messages;
  }
  Future<bool> send({ String text }) async {
    final reference = FirebaseDatabase.instance.reference().child('messages');
    reference.push().set({
      'text': text,
      'senderName': UserData.fullName,
    });
    return true;
  }
}

class FriendData {
  final String fullName;
  final String email;

  const FriendData({this.fullName, this.email});

  FriendData.fromMap(Map<String, dynamic> map)
      :
        fullName = "${map['name']['first']} ${map['name']['last']}",
        email = map['email'];
}

abstract class FriendRepository {
  Future<List<FriendData>> fetch();
}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}

class RandomUserRepository implements FriendRepository {

  static const _kRandomUserUrl = 'http://api.randomuser.me/?results=4';
  final JsonDecoder _decoder = new JsonDecoder();

  Future<List<FriendData>> fetch() {
    return http.get(_kRandomUserUrl)
        .then((http.Response response) {
      final String jsonBody = response.body;
      final statusCode = response.statusCode;

      if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        //throw new FetchDataException("Error while getting contacts [StatusCode:$statusCode, Error:${response.error}]");
      }

      final friendsContainer = _decoder.convert(jsonBody);
      final List contactItems = friendsContainer['results'];

      return contactItems.map((contactRaw) =>
      new FriendData.fromMap(contactRaw))
          .toList();
    });
  }
}