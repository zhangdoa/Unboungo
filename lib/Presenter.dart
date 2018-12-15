import 'package:unboungo/Model.dart';

abstract class UserAccountPresenter {
  void onSignedIn();
  void onSignedOut();
}

abstract class FriendDataPresenter {
  void onLoadFriendDataComplete(List<FirendData> items);
  void onLoadFriendDataError();
}

abstract class RecentChatPresenter {
  void onLoadRecentChatDataComplete(List<RecentChatData> items);
  void onLoadRecentChatDataError();
}

abstract class ChatMessagePresenter {
  void onLoadChatMessageComplete(List<ChatMessage> items);
  void onLoadChatMessageError();
}