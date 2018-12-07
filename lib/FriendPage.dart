import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/ChatScreen.dart';
import 'package:unboungo/Model.dart';
import 'package:unboungo/Interactor.dart';
import 'package:unboungo/Presenter.dart';

class FriendPage extends StatefulWidget {
  @override
  State createState() => new FriendPageState();
}

class FriendPageState extends State<FriendPage>
    implements FriendListPresenter {
  FriendPageState() {
    _interactor = new FriendListInteractor(this);
  }

  @override
  void initState() {
    super.initState();
    _isSearching = true;
    _interactor.loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFriendWidgets();
  }

  Widget _buildFriendWidgets() {
    if (_isSearching) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: CircularProgressIndicator()));
    } else {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _friendsData.length,
          itemBuilder: (context, index) {
            return FriendWidget(_friendsData[index].fullName, _friendsData[index].email);
          },
      );
    }
  }

  @override
  void onLoadFriendDataComplete(List<FriendData> items) {
    setState(() {
      _friendsData = items;
      _isSearching = false;
    });
  }

  @override
  void onLoadFriendDataError() {
    // TODO: implement onLoadFriendsError
  }

  FriendListInteractor _interactor;
  List<FriendData> _friendsData;
  bool _isSearching;
}

class FriendWidget extends StatelessWidget {
  final String _friendFullName;
  final String _friendEmail;

  FriendWidget(this._friendFullName, this._friendEmail);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(title: _friendFullName)),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: CircleAvatar(child: Text(_friendFullName[0])),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(_friendFullName,
                    style: Theme.of(context).textTheme.subhead),
              ),
            ],
          ),
        ));
  }
}
