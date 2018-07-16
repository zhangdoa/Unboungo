import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataLoader {
  static final DataLoader _singleton = new DataLoader._internal();

  factory DataLoader() {
    return _singleton;
  }

  DataLoader._internal();
}

class FriendData {
  final String fullName;
  final String email;

  const FriendData({this.fullName, this.email});
  FriendData.fromMap(Map<String, dynamic>  map) :
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

  Future<List<FriendData>> fetch(){
    return http.get(_kRandomUserUrl)
        .then((http.Response response) {
      final String jsonBody = response.body;
      final statusCode = response.statusCode;

      if(statusCode < 200 || statusCode >= 300 || jsonBody == null) {
        //throw new FetchDataException("Error while getting contacts [StatusCode:$statusCode, Error:${response.error}]");
      }

      final friendsContainer = _decoder.convert(jsonBody);
      final List contactItems = friendsContainer['results'];

      return contactItems.map( (contactRaw) => new FriendData.fromMap(contactRaw) )
          .toList();
    });
  }

}