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
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin
    implements ChatMessagePresenter {
  ChatScreenState() {
    _interactor = new ChatMessageInteractor(this);
  }

  @override
  void initState() {
    super.initState();
    _interactor.loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: getThemeData(),
        home: Scaffold(
          appBar: new AppBar(
            title: new Text(UserData.fullName),
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
        ));
  }

  @override
  void dispose() {
    for (ChatMessageWidget message in _chatMessageWidgets)
      message.animationController.dispose();
    super.dispose();
  }

  @override
  void onLoadChatMessageComplete(List<ChatMessage> items) {
    _buildChatMessageWidgets(items[0].messages);
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
    _buildChatMessageWidgets(text);
    _sendMessage(text: text);
    setState(() {
      _isComposing = false;
    });
  }

  void _buildChatMessageWidgets(String text) {
    ChatMessageWidget chatMessageWidget = new ChatMessageWidget(
      userFullName: UserData.fullName,
      isLocalUser: true,
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

  void _sendMessage({String text, String imageUrl}) {
    _interactor.send(text: text);
  }

  ChatMessageInteractor _interactor;
  final List<ChatMessageWidget> _chatMessageWidgets = <ChatMessageWidget>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
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
                    buildUserAvatar(),
                  ]
                : <Widget>[
                    buildUserAvatar(),
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

  Widget buildUserAvatar() {
    return new Container(
      margin: const EdgeInsets.fromLTRB(4.0, 4.0, 0.0, 0.0),
      child: new CircleAvatar(child: new Text(userFullName[0])),
    );
  }
}
