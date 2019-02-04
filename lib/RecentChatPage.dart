import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/Theme.dart';
import 'package:unboungo/WidgetBuilders.dart';
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
            : _recentChatDatas.length == 0
                ? Center(
                    child: UBWidgetBuilder().buildSplitText(
                        context, "Find a friend and let's chat!", Colors.grey))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _recentChatDatas.length,
                    itemBuilder: (_, index) {
                      return UBWidgetBuilder().buildRecentChatButton(
                          context,
                          _recentChatDatas[index].userName,
                          Colors.white,
                          _recentChatDatas[index].lastMessage,
                          _onRecentButtonPressed);
                    },
                  ));
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

  void _onRecentButtonPressed(text) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(title: text)),
    );
  }

  RecentChatInteractor _interactor;
  List<RecentChatData> _recentChatDatas;
  bool _isLoading;
}
