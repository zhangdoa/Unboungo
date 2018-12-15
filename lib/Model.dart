import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccountManager {
  static final UserAccountManager _singleton =
      new UserAccountManager._internal();

  final _googleSignIn = new GoogleSignIn();
  final _firebaseAuth = new FirebaseAuth.fromApp(FirebaseApp.instance);
  final _firestore = Firestore.instance;

  factory UserAccountManager() {
    return _singleton;
  }

  UserAccountManager._internal();

  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final FirebaseUser firebaseUser = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    assert(firebaseUser.email != null);
    assert(firebaseUser.displayName != null);
    assert(!firebaseUser.isAnonymous);
    assert(await firebaseUser.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(firebaseUser.uid == currentUser.uid);

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await _firestore
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        _firestore.collection('users').document(firebaseUser.uid).setData(
            {'nickname': firebaseUser.displayName, 'id': firebaseUser.uid});
      }
    }

    UserData.fullName = firebaseUser.displayName;
    UserData.email = firebaseUser.email;

    return true;
  }

  Future<bool> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();

    return true;
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

class FirendData {
  final String fullName;
  final String email;

  const FirendData({this.fullName, this.email});

  FirendData.fromMap(Map<String, dynamic> map)
      : fullName = "${map['name']['first']} ${map['name']['last']}",
        email = map['email'];
}

abstract class FriendRepository {
  Future<List<FirendData>> fetch();
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

  Future<List<FirendData>> fetch() {}
}

class RecentChatData {
  final String lastMessage;
  final String userName;

  const RecentChatData({this.lastMessage, this.userName});

  RecentChatData.fromMap(Map<String, dynamic> map)
      : lastMessage = map['lastMessage'] ,
        userName ="${map['name']['first']} ${map['name']['last']}";
}

abstract class RecentChatRepository {
  Future<List<RecentChatData>> fetch();
}

class FirebaseRecentChatRepository implements RecentChatRepository {
  Future<List<RecentChatData>> fetch() {
  }
}

class ChatMessage {
  final String fullName;
  final String messages;

  const ChatMessage({this.fullName, this.messages});

  ChatMessage.fromMap(Map<String, dynamic> map)
      : fullName = "${map['senderName']['first']} ${map['senderName']['last']}",
        messages = map['text'];
}

abstract class ChatMessageRepository {
  Future<List<ChatMessage>> fetch();

  Future<bool> send({String text});
}

class FirebaseChatMessageRepository implements ChatMessageRepository {
  Future<List<ChatMessage>> fetch() async {}

  Future<bool> send({String text}) async {
    return true;
  }
}