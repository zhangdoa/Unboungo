import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';

class UserAccountManager {
  static final UserAccountManager _singleton =
      new UserAccountManager._internal();

  final _googleSignIn = new GoogleSignIn();

  //final _facebookSignIn = new FacebookLogin();
  final _firebaseAuth = new FirebaseAuth.fromApp(FirebaseApp.instance);
  final _firestore = Firestore.instance;

  factory UserAccountManager() {
    return _singleton;
  }

  UserAccountManager._internal();

  Future<bool> signInWithEmail(userEmail, userPassword) async {
    FirebaseUser firebaseUser;
    try {
      firebaseUser = await _firebaseAuth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);
    } catch (e) {
      print(e);
    }

    if (firebaseUser == null) {
      firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
      UserUpdateInfo info = new UserUpdateInfo();
      info.displayName = userEmail;
      await firebaseUser.updateProfile(info);
      await firebaseUser.reload();
      firebaseUser = await _firebaseAuth.currentUser();
    }

    await validateFirebaseUser(firebaseUser);

    await saveFirebaseUser(firebaseUser);

    return true;
  }

  Future<bool> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final FirebaseUser firebaseUser = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await validateFirebaseUser(firebaseUser);

    await saveFirebaseUser(firebaseUser);

    return true;
  }

  Future saveFirebaseUser(FirebaseUser firebaseUser) async {
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
        _firestore
            .collection('users')
            .document(firebaseUser.uid)
            .collection('friends')
            .document('initializer')
            .setData({
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
        });
        _firestore
            .collection('users')
            .document(firebaseUser.uid)
            .collection('chatMessages')
            .document('initializer')
            .setData({
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
        });
      }
    }

    UserData.fullName = firebaseUser.displayName;
    UserData.email = firebaseUser.email;
    UserData._uid = firebaseUser.uid;
  }

  Future validateFirebaseUser(FirebaseUser firebaseUser) async {
    assert(firebaseUser.email != null);
    assert(firebaseUser.displayName != null);
    assert(!firebaseUser.isAnonymous);
    assert(await firebaseUser.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(firebaseUser.uid == currentUser.uid);
  }

  Future<bool> signInWithFacebook() async {
//    final facebookSignInResult = await _facebookSignIn
//        .logInWithReadPermissions(['email', 'public_profile']);
//    if (facebookSignInResult.status == FacebookLoginStatus.loggedIn) {
//      final FirebaseUser firebaseUser = await _firebaseAuth.signInWithFacebook(
//          accessToken: facebookSignInResult.accessToken.token);
//
//      await validateFirebaseUser(firebaseUser);
//
//      UserData.fullName = firebaseUser.displayName;
//      UserData.email = firebaseUser.email;
//    }

    return true;
  }

  Future<bool> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();

    return true;
  }

  Future<List<RecentChatData>> fetchRecentChatData() async {
    final chatMessageCollection = _firestore
        .collection('users')
        .document(UserData._uid)
        .collection('chatMessages');
    final chatMessageQuerySnapshot = await chatMessageCollection.getDocuments();
    final List<DocumentSnapshot> documents = chatMessageQuerySnapshot.documents;
    List<RecentChatData> result = [];
    await Future.forEach(documents, (documentSnapshot) async {
      if (documentSnapshot.documentID != 'initializer') {
        final val = RecentChatData();
        String chatMessageId = documentSnapshot.documentID;
        final chatMessageContentCollection = _firestore
            .collection('chatMessages')
            .document(chatMessageId)
            .collection('content');
        final lastMessage = await chatMessageContentCollection
            .orderBy("timestamp", descending: true)
            .limit(1)
            .getDocuments();
        var senderName = await getUserName(lastMessage.documents[0]['sender']);
        var receiverName = await getUserName(lastMessage.documents[0]['receiver']);
        val.userName = senderName == UserData.fullName ? receiverName : senderName;
        val.lastMessage = await lastMessage.documents[0]['message'];
        result.add(val);
      }
    });
    return result;
  }

  Future<List<ChatMessage>> fetchChatMessageData(friendName) async {
    final friendId = await getUserId(friendName);
    final chatMessageId = getChatCollectionId(UserData._uid, friendId);

    final chatMessageCollection = _firestore.collection('chatMessages');

    final chatMessageQuerySnapshot = await chatMessageCollection
        .document(chatMessageId)
        .collection('content')
        .getDocuments();

    final chatMessageDocuments = chatMessageQuerySnapshot.documents;

    List<ChatMessage> result = [];
    await Future.forEach(chatMessageDocuments, (documentSnapshot) async {
      final val = ChatMessage();
      final senderName = await getUserName(documentSnapshot['sender']);
      val.fullName = senderName;
      val.messages = await documentSnapshot['message'];
      result.add(val);
    });
    return result;
  }

  Future<List<FriendData>> fetchFriendData() async {
    final userFriendsCollection = _firestore
        .collection('users')
        .document(UserData._uid)
        .collection('friends');
    final QuerySnapshot userFriendsQuerySnapshot =
        await userFriendsCollection.getDocuments();
    final List<DocumentSnapshot> documents = userFriendsQuerySnapshot.documents;
    List<FriendData> result = [];
    await Future.forEach(documents, (documentSnapshot) async {
      if (documentSnapshot.documentID != 'initializer') {
        final val = FriendData();
        String friendId = documentSnapshot.documentID;
        val.fullName = await getUserName(friendId);
        result.add(val);
      }
    });
    return result;
  }

  Future<List<String>> searchFriend(name) async {
    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('nickname', isEqualTo: name)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    List<String> suitableFriends = [];
    if (documents.length != 0) {
      documents.forEach((snapshot) {
        if (snapshot['nickname'] != UserData.fullName) {
          suitableFriends.add(snapshot['nickname']);
        }
      });
    }
    return suitableFriends;
  }

  Future<String> getUserName(id) async {
    final QuerySnapshot userDataQuerySnapshot = await _firestore
        .collection('users')
        .where('id', isEqualTo: id)
        .getDocuments();
    final List<DocumentSnapshot> userDataDocumentSnapshot =
        userDataQuerySnapshot.documents;

    var userName;
    if (userDataDocumentSnapshot.length != 0) {
      userDataDocumentSnapshot.forEach((snapshot) {
        userName = snapshot['nickname'].toString();
      });
      return userName;
    } else {
      return 'InvalidUserName';
    }
  }

  Future<String> getUserId(name) async {
    final QuerySnapshot userDataQuerySnapshot = await _firestore
        .collection('users')
        .where('nickname', isEqualTo: name)
        .getDocuments();
    final List<DocumentSnapshot> userDataDocumentSnapshot =
        userDataQuerySnapshot.documents;

    var userId;
    if (userDataDocumentSnapshot.length != 0) {
      userDataDocumentSnapshot.forEach((snapshot) {
        userId = snapshot['id'];
      });

      return userId;
    } else {
      return 'InvalidUserId';
    }
  }

  Future addFriend(name) async {
    var friendId = await getUserId(name);
    await addFriendToFirestore(UserData._uid, friendId, name);
    await addFriendToFirestore(friendId, UserData._uid, UserData.fullName);
    final chatMessage = _firestore
        .collection('chatMessages')
        .document(getChatCollectionId(UserData._uid, friendId));
    await chatMessage.setData(
        {'timestamp': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Future addFriendToFirestore(userId, friendId, friendName) async {
    final userFriendsCollection =
        _firestore.collection('users').document(userId).collection('friends');
    final queryResult = await userFriendsCollection.document(friendId).get();
    if (!queryResult.exists) {
      await userFriendsCollection
          .document(friendId)
          .setData({'nickname': friendName});
      final chatMessage = _firestore
          .collection('users')
          .document(userId)
          .collection('chatMessages')
          .document(getChatCollectionId(userId, friendId));
      await chatMessage.setData(
          {'timestamp': DateTime.now().millisecondsSinceEpoch.toString()});
      print("User: " + userId + " :New friend added");
    } else {
      print("User: " + userId + " :Friend already added");
    }
  }

  Future sendChatMessage(name, message) async {
    var userId = UserData._uid;
    var friendId = await getUserId(name);
    var chatMessageId = getChatCollectionId(userId, friendId);

    final chatMessageCollection =
        _firestore.collection('chatMessages').document(chatMessageId);
    chatMessageCollection.collection('content').add({
      'sender': userId,
      'receiver': friendId,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'message': message
    });
  }

  getChatCollectionId(String userId, String friendId) {
    var chatMessageId;
    if (userId.hashCode <= friendId.hashCode) {
      chatMessageId = '$userId-$friendId';
    } else {
      chatMessageId = '$friendId-$userId';
    }
    return chatMessageId;
  }
}

class UserData {
  static final UserData _singleton = new UserData._internal();
  static String fullName;
  static String email;
  static String _uid;

  factory UserData() {
    return _singleton;
  }

  UserData._internal();
}

class FriendData {
  String fullName;

  FriendData({this.fullName});
}

abstract class FriendRepository {
  Future<List<FriendData>> fetch();

  Future<List<String>> searchFriend(name);

  Future addFriend(name);
}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}

class FirebaseFriendRepository implements FriendRepository {
  Future<List<String>> searchFriend(name) async {
    var result = await UserAccountManager().searchFriend(name);
    return result;
  }

  Future<List<FriendData>> fetch() async {
    var result = await UserAccountManager().fetchFriendData();
    return result;
  }

  Future addFriend(name) async {
    await UserAccountManager().addFriend(name);
  }
}

class RecentChatData {
  String lastMessage;
  String userName;

  RecentChatData({this.lastMessage, this.userName});
}

abstract class RecentChatRepository {
  Future<List<RecentChatData>> fetch();
}

class FirebaseRecentChatRepository implements RecentChatRepository {
  Future<List<RecentChatData>> fetch() async {
    var result = await UserAccountManager().fetchRecentChatData();
    return result;
  }
}

class ChatMessage {
  String fullName;
  String messages;

  ChatMessage({this.fullName, this.messages});
}

abstract class ChatMessageRepository {
  Future<List<ChatMessage>> fetch(friendName);

  Future<bool> send(name, message);
}

class FirebaseChatMessageRepository implements ChatMessageRepository {
  Future<List<ChatMessage>> fetch(friendName) async {
    var result = await UserAccountManager().fetchChatMessageData(friendName);
    return result;
  }

  Future<bool> send(name, message) async {
    await UserAccountManager().sendChatMessage(name, message);
    return true;
  }
}

class UbUtilities {
  Future<Map<String, String>> getAndroidDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    Map<String, String> results = new Map();
    results.putIfAbsent('AndroidID', () => androidInfo.androidId);
    results.putIfAbsent('Board', () => androidInfo.board);
    results.putIfAbsent('Bootloader', () => androidInfo.bootloader);
    results.putIfAbsent('Brand', () => androidInfo.brand);
    results.putIfAbsent('Device', () => androidInfo.device);
    results.putIfAbsent('Display', () => androidInfo.display);
    results.putIfAbsent('Fingerprint', () => androidInfo.fingerprint);
    results.putIfAbsent('Hardware', () => androidInfo.hardware);
    results.putIfAbsent('Host', () => androidInfo.host);
    results.putIfAbsent(
        'Is Physical Device', () => androidInfo.isPhysicalDevice.toString());
    results.putIfAbsent('Manufacturer', () => androidInfo.manufacturer);
    results.putIfAbsent('Model', () => androidInfo.model);
    results.putIfAbsent('Product', () => androidInfo.product);
    androidInfo.supported32BitAbis.forEach((String val) =>
        results.putIfAbsent('Supported 32-Bit Abis', () => val));
    androidInfo.supported64BitAbis.forEach((String val) =>
        results.putIfAbsent('Supported 64-Bit Abis', () => val));
    results.putIfAbsent('Tags', () => androidInfo.tags);
    results.putIfAbsent('Type', () => androidInfo.type);
    results.putIfAbsent('Base OS', () => androidInfo.version.baseOS);
    results.putIfAbsent('Codename', () => androidInfo.version.codename);
    results.putIfAbsent('Incremental', () => androidInfo.version.incremental);
    results.putIfAbsent('Release', () => androidInfo.version.release);
    results.putIfAbsent(
        'SecurityPatch', () => androidInfo.version.securityPatch);
    return results;
  }

  Future<List<String>> getIOSDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    List<String> result;
    result.add(iosInfo.localizedModel);
    result.add(iosInfo.model);
    return result;
  }

  static final UbUtilities _singleton = new UbUtilities._internal();

  factory UbUtilities() {
    return _singleton;
  }

  UbUtilities._internal();
}
