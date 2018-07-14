import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:english_words/english_words.dart';

import 'package:unboungo/ChatScreen.dart';

class RecentChatPage extends StatefulWidget {
  @override
  State createState() => new RecentChatPageState();
}

class RecentChatPageState extends State<RecentChatPage> {
  @override
  Widget build(BuildContext context) {
    return _buildRecentChats();
  }

  Widget _buildRecentChats() {
    _recentChats.add(new RecentChat());
    return ListView(
      shrinkWrap: true,
      children: _recentChats,
    );
  }

  Widget _buildRow(RecentChat recentChat) {
    return new ListTile(
      title: new Text(
        recentChat._lastMessage,
        style: _biggerFont,
      ),
    );
  }

  final List<RecentChat> _recentChats = <RecentChat>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
}

class RecentChat extends StatelessWidget {
  final String _lastMessage = "Eat less!!!";
  final String _userName = "M";
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: new CircleAvatar(child: new Text(_userName[0])),
          ),
          new Expanded(
              child: new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_userName, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(_lastMessage),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
