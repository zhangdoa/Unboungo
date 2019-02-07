import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/WidgetBuilders.dart';
import 'package:unboungo/Model.dart';
import 'package:unboungo/Interactor.dart';
import 'package:unboungo/Presenter.dart';
import 'package:unboungo/Theme.dart';

class ChatScreen extends StatefulWidget {
  final String friendName;

  ChatScreen({
    Key key,
    this.friendName,
  }) : super(key: key);

  @override
  State createState() => new ChatScreenState(friendName);
}

class ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin
    implements ChatMessagePresenter {
  ChatScreenState(friendName) {
    _interactor = new ChatMessageInteractor(this);
    _friendName = friendName;
  }

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() {
    _interactor
        .getFriendId(_friendName)
        .then((friendId) => setFriendId(friendId));
  }

  void setFriendId(friendId) {
    setState(() {
      _friendId = friendId;
      _chatId = UbUtilities().getChatId(UserData.uid, friendId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(_friendName),
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
              Flexible(
                child: _buildChatMessages(),
              ),
              new Divider(height: 4.0),
              _buildTextComposer(),
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
    items.forEach((item) {});
  }

  @override
  void onLoadChatMessageError() {
    // TODO: implement onLoadFriendsError
  }

  Widget _buildChatMessages() {
    return StreamBuilder(
        stream: FirestoreWrapper()
            .getFirestoreInstance()
            .collection('chatMessages')
            .document(_chatId)
            .collection('content')
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          var documents = snapshot.data.documents;
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            reverse: true,
            itemBuilder: (_, index) {
              var isLocalSent = documents[index]['sender'] == UserData.uid;
              return _buildChatMessageWidgets(
                  isLocalSent ? UserData.fullName : _friendName,
                  documents[index]['message'],
                  isLocalSent);
            },
            itemCount: documents.length,
          );
        });
  }

  Widget _buildTextComposer() {
    return new Container(
        decoration: new BoxDecoration(color: Theme.of(context).cardColor),
        child: IconTheme(
          data: new IconThemeData(color: Theme.of(context).accentColor),
          child: new Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    controller: _textController,
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
                        onPressed: () =>
                            _handleSubmitted(_textController.text))),
              ],
            ),
          ),
        ));
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    _sendMessage(_friendId, text);
  }

  Widget _buildChatMessageWidgets(String userName, String text, isLocalUser) {
    var chatMessageWidget = new ChatMessageWidget(
      userFullName: userName,
      isLocalUser: isLocalUser,
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _chatMessageWidgets.insert(0, chatMessageWidget);
    chatMessageWidget.animationController.forward();

    return chatMessageWidget;
  }

  void _sendMessage(name, message) {
    _interactor.send(name, message);
  }

  ChatMessageInteractor _interactor;
  final List<ChatMessageWidget> _chatMessageWidgets = <ChatMessageWidget>[];
  final TextEditingController _textController = new TextEditingController();
  String _friendName;
  String _friendId;
  String _chatId;
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
