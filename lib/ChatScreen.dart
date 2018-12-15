import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

import 'package:unboungo/Model.dart';
import 'package:unboungo/Interactor.dart';
import 'package:unboungo/Presenter.dart';

class ChatScreen extends StatefulWidget {
 final String title;
  ChatScreen({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin implements ChatMessagePresenter {
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: _buildChatMessages(),
              ),
              new Divider(height: 1.0),
              new Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border: new Border(
                    top: new BorderSide(color: Colors.grey[200]),
                  ),
                )
              : null
      ),
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
    _buildChatMessageWidgets(items[0].messages);
  }

  @override
  void onLoadChatMessageError() {
    // TODO: implement onLoadFriendsError
  }

  Widget _buildChatMessages() {
   return  new ListView.builder(
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
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? new CupertinoButton(
                        child: new Text("Send"),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    : new IconButton(
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
    setState(() {
      _isComposing = false;
    });
    _buildChatMessageWidgets(text);
    _sendMessage(text : text);
  }

  void _buildChatMessageWidgets(String text) {
    ChatMessageWidget chatMessageWidget = new ChatMessageWidget(
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

  void _sendMessage({ String text, String imageUrl }) {
    _interactor.send(text : text);
  }

  ChatMessageInteractor _interactor;
  final List<ChatMessageWidget> _chatMessageWidgets = <ChatMessageWidget>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
}

class ChatMessageWidget extends StatelessWidget {
  ChatMessageWidget({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  String _userFullName = UserData.fullName;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 2.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text(_userFullName, style: Theme.of(context).textTheme.subhead),
                    new Container(
                      child: new Text(text),
                    ),
                  ],
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(left: 8.0),
                child: new CircleAvatar(child: new Text(_userFullName[0])),
              ),
            ],
          ),
        ));
  }
}
