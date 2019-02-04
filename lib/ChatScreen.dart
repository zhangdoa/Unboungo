import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/WidgetBuilders.dart';
import 'package:unboungo/Model.dart';
import 'package:unboungo/Interactor.dart';
import 'package:unboungo/Presenter.dart';
import 'package:unboungo/Theme.dart';

class ChatScreen extends StatefulWidget {
  final String title;

  ChatScreen({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  State createState() => new ChatScreenState(title);
}

class ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin
    implements ChatMessagePresenter {
  ChatScreenState(title) {
    _interactor = new ChatMessageInteractor(this);
    _title = title;
  }

  @override
  void initState() {
    super.initState();
    _interactor.loadMessages(_title);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child:  Scaffold(
            appBar: new AppBar(
              title: new Text(_title),
              backgroundColor: getThemeData().accentColor,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: new Container(
              decoration: new BoxDecoration(
                color: getThemeData().backgroundColor,
              ),
              child: new Column(
                children: <Widget>[
                  new Flexible(
                    child: _buildChatMessages(),
                  ),
                  new Divider(height: 4.0),
                  new Container(
                    decoration:
                        new BoxDecoration(color: Theme.of(context).cardColor),
                    child: _buildTextComposer(),
                  ),
                ],
              ),
            ),
          ),
      onWillPop: () async => false,
    );
  }

  @override
  void dispose() {
    for (ChatMessageWidget message in _chatMessageWidgets)
      message.animationController.dispose();
    super.dispose();
  }

  @override
  void onLoadChatMessageComplete(List<ChatMessage> items) {
    items.forEach((item) {
      _buildChatMessageWidgets(
          item.fullName, item.messages, item.fullName == UserData.fullName);
    });
  }

  @override
  void onLoadChatMessageError() {
    // TODO: implement onLoadFriendsError
  }

  Widget _buildChatMessages() {
    return new ListView.builder(
      padding: new EdgeInsets.all(8.0),
      reverse: true,
      itemBuilder: (_, int index) => _chatMessageWidgets[index],
      itemCount: _chatMessageWidgets.length,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Do you know who I am?'),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null,
                )),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    _buildChatMessageWidgets(UserData.fullName, text, true);
    _sendMessage(_title, text);
    setState(() {
      _isComposing = false;
    });
  }

  void _buildChatMessageWidgets(String userName, String text, isLocalUser) {
    ChatMessageWidget chatMessageWidget = new ChatMessageWidget(
      userFullName: userName,
      isLocalUser: isLocalUser,
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    setState(() {
      _chatMessageWidgets.insert(0, chatMessageWidget);
    });
    chatMessageWidget.animationController.forward();
  }

  void _sendMessage(name, message) {
    _interactor.send(name, message);
  }

  ChatMessageInteractor _interactor;
  final List<ChatMessageWidget> _chatMessageWidgets = <ChatMessageWidget>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  String _title;
}

class ChatMessageWidget extends StatelessWidget {
  ChatMessageWidget(
      {this.userFullName,
      this.isLocalUser,
      this.text,
      this.animationController});

  final String userFullName;
  final bool isLocalUser;
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: isLocalUser
                ? <Widget>[
                    buildSingleChatMessage(),
                    UBWidgetBuilder().buildUserAvatar(context, userFullName[0]),
                  ]
                : <Widget>[
                    UBWidgetBuilder().buildUserAvatar(context, userFullName[0]),
                    buildSingleChatMessage(),
                  ],
          ),
        ));
  }

  Widget buildSingleChatMessage() {
    return new Expanded(
        child: new Column(
      crossAxisAlignment:
          isLocalUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        new Text(userFullName,
            style: TextStyle(color: Colors.grey, fontSize: 12.0)),
        Container(
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: getThemeData().accentColor,
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: new Container(
            margin: const EdgeInsets.fromLTRB(12.0, 12.0, 6.0, 6.0),
            child: new Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        )
      ],
    ));
  }
}
