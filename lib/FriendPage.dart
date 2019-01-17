import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
    return _buildFriendWidgets();
  }

  Widget _buildFriendWidgets() {
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
                    : UBWidgetBuilder().buildDivider(context, 80.0),
                _friendsDatas == null
                    ? Center(
                        child: UBWidgetBuilder().buildSplitText(
                            context, "Add some friends now!", Colors.grey))
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: _friendsDatas.length,
                        itemBuilder: (context, index) {
                          FriendWidget(_friendsDatas[index].fullName);
                        },
                      )
              ]));
  }

  Widget buildFriendSearchBar() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
        constraints: BoxConstraints(maxHeight: 200.0, minHeight: 100.0),
        child: _searchFriendResult == null
            ? ListView(children: <Widget>[
                UBWidgetBuilder()
                    .buildSplitText(context, "No result found", Colors.black)
              ])
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _searchFriendResult.length,
                itemBuilder: (context, index) {
                  UBWidgetBuilder().buildSplitText(
                      context, _searchFriendResult[index], Colors.white);
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
  }

  void _onFriendInputFieldSubmitted(text) {
    setState(() {
      _isTyping = false;
    });
  }

  void _onFriendInputFieldChanged(text) {
    searchFriends(text);
    setState(() {
      _newFriendName = text;
    });
  }

  void searchFriends(text) async {
    _searchFriendResult = await _interactor.searchFriend(text);
  }

  void _onFriendSearchingResultPressed(text) {}

  final TextEditingController _friendTextController =
      new TextEditingController();
  String _newFriendName;
  bool _isTyping = false;
  FriendInteractor _interactor;
  List<String> _searchFriendResult;
  List<FriendData> _friendsDatas;
  bool _isLoading;
}

class FriendWidget extends StatelessWidget {
  final String _friendFullName;

  FriendWidget(this._friendFullName);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(title: _friendFullName)),
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
