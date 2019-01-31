import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/Theme.dart';
import 'package:unboungo/WidgetBuilders.dart';
import 'package:unboungo/ChatScreen.dart';
import 'package:unboungo/Model.dart';
import 'package:unboungo/Interactor.dart';
import 'package:unboungo/Presenter.dart';

class FriendPage extends StatefulWidget {
  @override
  State createState() => new FriendPageState();
}

class FriendPageState extends State<FriendPage> implements FriendDataPresenter {
  FriendPageState() {
    _interactor = new FriendInteractor(this);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _interactor.loadFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: getThemeData().backgroundColor,
        ),
        child: _isLoading
            ? Center(
                child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: UBWidgetBuilder()
                        .buildLoadingCircularProgressIndicator(
                            getThemeData().accentColor)))
            : Column(children: <Widget>[
                UBWidgetBuilder().buildDivider(context, 80.0),
                UBWidgetBuilder().buildInputFieldContainer(
                    context,
                    'Who you want to talk with?',
                    _friendTextController,
                    _onFriendInputFieldTap,
                    _onFriendInputFieldSubmitted,
                    _onFriendInputFieldChanged,
                    false),
                _isTyping
                    ? buildFriendSearchBar()
                    : UBWidgetBuilder().buildDivider(context, 40.0),
                _showAddFriendDialog
                    ? AlertDialog(
                        title: new Text("Add friend"),
                        content: new Text(
                            "Send a friend request to " + _newFriendName + "?"),
                        actions: <Widget>[
                            FlatButton(
                                child: new Text("Nu"),
                                onPressed: () {
                                  setState(() {
                                    _isTyping = false;
                                    _showAddFriendDialog = false;
                                  });
                                }),
                            FlatButton(
                              child: new Text("Da"),
                              onPressed: _sendFriendRequest,
                            )
                          ])
                    : UBWidgetBuilder().buildDivider(context, 40.0),
                _buildFriendWidgets()
              ]));
  }

  Widget _buildFriendWidgets() {
    return _friendsDatas.length == 0
        ? Center(
            child: UBWidgetBuilder()
                .buildSplitText(context, "Add some friends now!", Colors.grey))
        : ListView.builder(
            shrinkWrap: true,
            itemCount: _friendsDatas.length,
            itemBuilder: (_, index) {
              return Container(
                  child: UBWidgetBuilder().buildFriendButton(
                      context,
                      _friendsDatas[index].fullName,
                      Colors.white,
                      _onFriendButtonPressed));
            },
          );
  }

  Widget buildFriendSearchBar() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
        constraints:
            BoxConstraints(maxHeight: 200.0, minHeight: 100.0, maxWidth: 300.0),
        child: _searchFriendResult.length == 0
            ? ListView(children: <Widget>[
                UBWidgetBuilder()
                    .buildSplitText(context, "No result found", Colors.black)
              ])
            : ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: _searchFriendResult.length,
                itemBuilder: (_, index) {
                  return UBWidgetBuilder().buildFriendButton(
                      context,
                      _searchFriendResult[index],
                      Colors.black,
                      _onFriendSearchingResultPressed);
                }));
  }

  @override
  void onLoadFriendDataComplete(List<FriendData> items) {
    setState(() {
      _friendsDatas = items;
      _isLoading = false;
    });
  }

  @override
  void onLoadFriendDataError() {
    // TODO: implement onLoadFriendsError
  }

  void _onFriendInputFieldTap() {
    setState(() {
      _isTyping = true;
    });
    if (_newFriendName.isNotEmpty) {
      _searchFriends(_newFriendName);
    }
  }

  void _onFriendInputFieldSubmitted(text) {
    setState(() {
      _isTyping = false;
    });
  }

  void _onFriendInputFieldChanged(text) {
    _searchFriends(text);
  }

  void _searchFriends(text) async {
    _searchFriendResult = await _interactor.searchFriend(text);
    setState(() {
      _newFriendName = text;
    });
  }

  void _onFriendSearchingResultPressed(text) async {
    setState(() {
      _isTyping = false;
      _showAddFriendDialog = true;
    });
  }

  void _sendFriendRequest() async {
    setState(() {
      _showAddFriendDialog = false;
    });
    await _interactor.addFriend(_newFriendName);
    setState(() {
      _isLoading = true;
    });
    _interactor.loadFriends();
  }

  void _onFriendButtonPressed(text) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(title: text)),
    );
  }

  final TextEditingController _friendTextController =
      new TextEditingController();
  String _newFriendName = '';
  bool _isTyping = false;
  FriendInteractor _interactor;
  List<String> _searchFriendResult = [];
  List<FriendData> _friendsDatas = [];
  bool _isLoading;
  bool _showAddFriendDialog = false;
}
