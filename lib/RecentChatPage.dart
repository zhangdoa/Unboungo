import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/ChatScreen.dart';
import 'package:unboungo/Model.dart';
import 'package:unboungo/Interactor.dart';
import 'package:unboungo/Presenter.dart';

class RecentChatPage extends StatefulWidget {
  @override
  State createState() => new RecentChatPageState();
}

class RecentChatPageState extends State<RecentChatPage>
    implements RecentChatPresenter {
  RecentChatPageState() {
    _interactor = new RecentChatInteractor(this);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _interactor.loadRecentChats();
  }

  @override
  Widget build(BuildContext context) {
    return _buildRecentChatWidgets();
  }

  Widget _buildRecentChatWidgets() {
    if (_isLoading) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: CircularProgressIndicator()));
    } else {
      if (_recentChatDatas.length == 0) {
        return new Text("Find a friend and let's chat!");
      } else {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _recentChatDatas.length,
          itemBuilder: (context, index) {
            return RecentChatWidget(_recentChatDatas[index].lastMessage,
                _recentChatDatas[index].userName);
          },
        );
      }
    }
  }

  @override
  void onLoadRecentChatDataComplete(List<RecentChatData> items) {
    setState(() {
      _recentChatDatas = items;
      _isLoading = false;
    });
  }

  @override
  void onLoadRecentChatDataError() {
    // TODO: implement onLoadFriendsError
  }

  RecentChatInteractor _interactor;
  List<RecentChatData> _recentChatDatas;
  bool _isLoading;
}

class RecentChatWidget extends StatelessWidget {
  final String _lastMessage;
  final String _userName;

  RecentChatWidget(this._lastMessage, this._userName);

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
                MaterialPageRoute(
                    builder: (context) => ChatScreen(title: _userName)),
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
