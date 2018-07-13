import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

class FriendPage extends StatefulWidget{
  @override
  State createState() => new FriendPageState();
}

class FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    return _buildFriends();
  }
  Widget _buildFriends() {
    _friends.add(new Friend());
    return ListView(
      shrinkWrap: true,
      children: _friends,
    );
  }
  final List<Friend> _friends = <Friend>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
}

class Friend extends StatelessWidget {
  final String _userName = "Misky";
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CircleAvatar(child: new Text(_userName[0])),
          ),
          new Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Text(_userName, style: Theme.of(context).textTheme.subhead),
          ),
        ],
      ),
    );
  }
}