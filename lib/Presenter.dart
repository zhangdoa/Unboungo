import 'package:unboungo/Model.dart';

abstract class UserAccountPresenter {
  void onSignedIn();
  void onSignedOut();
}

abstract class FriendListPresenter {
  void onLoadFriendDataComplete(List<FriendData> items);
  void onLoadFriendDataError();
}

abstract class ChatMessageListPresenter {
  void onLoadChatMessageComplete(List<ChatMessage> items);
  void onLoadChatMessageError();
}