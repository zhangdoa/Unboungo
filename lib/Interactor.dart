import 'package:unboungo/Model.dart';
import 'package:unboungo/Presenter.dart';

class UserAccountInteractor {
  UserAccountPresenter _presenter;

  UserAccountInteractor(this._presenter) {}

  Future<bool> signInWithEmail(userEmail, userPassword) async {
    await UserAccountManager().signInWithEmail(userEmail, userPassword);
    _presenter.onSignedIn();
    return true;
  }

  Future<bool> signInWithGoogle() async {
    await UserAccountManager().signInWithGoogle();
    _presenter.onSignedIn();
    return true;
  }

  Future<bool> signInWithFacebook() async {
    await UserAccountManager().signInWithFacebook();
    _presenter.onSignedIn();
    return true;
  }

  Future<bool> signOut() async {
    await UserAccountManager().signOut();
    _presenter.onSignedOut();
    return true;
  }
}

class FriendInteractor {
  FriendDataPresenter _presenter;
  FriendRepository _repository;

  FriendInteractor(this._presenter) {
    _repository = new FirebaseFriendRepository();
  }

  void loadFriends() {
    assert(_presenter != null);

    _repository
        .fetch()
        .then((contacts) => _presenter.onLoadFriendDataComplete(contacts))
        .catchError((onError) {
      print(onError);
      _presenter.onLoadFriendDataError();
    });
  }

  Future<List<String>> searchFriend(name) async {
    var result = await _repository.searchFriend(name);
    return result;
  }

  Future addFriend(name) async {
    await _repository.addFriend(name);
  }
}

class RecentChatInteractor {
  RecentChatPresenter _presenter;
  RecentChatRepository _repository;

  RecentChatInteractor(this._presenter) {
    _repository = new FirebaseRecentChatRepository();
  }

  void loadRecentChats() {
    assert(_presenter != null);

    _repository
        .fetch()
        .then((contacts) => _presenter.onLoadRecentChatDataComplete(contacts))
        .catchError((onError) {
      print(onError);
      _presenter.onLoadRecentChatDataError();
    });
  }
}

class ChatMessageInteractor {
  ChatMessagePresenter _presenter;
  ChatMessageRepository _repository;

  ChatMessageInteractor(this._presenter) {
    _repository = new FirebaseChatMessageRepository();
  }

  Future<String> getFriendId(friendName) async {
    assert(_presenter != null);
    assert(friendName != null);

    return await _repository.getFriendId(friendName);
  }

  void loadMessages(friendId) {
    assert(_presenter != null);
    assert(friendId != null);

    _repository
        .fetch(friendId)
        .then((messages) => _presenter.onLoadChatMessageComplete(messages))
        .catchError((onError) {
      print(onError);
      _presenter.onLoadChatMessageError();
    });
  }

  Future<bool> send(friendId, message) async {
    _repository.send(friendId, message);
    return true;
  }
}
