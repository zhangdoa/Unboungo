import 'package:unboungo/Model.dart';
import 'package:unboungo/Presenter.dart';

class FriendListInteractor {
  FriendListPresenter _presenter;
  FriendRepository _repository;

  FriendListInteractor(this._presenter){
    _repository = new RandomUserRepository();
  }

  void loadFriends(){
    assert(_presenter != null);

    _repository.fetch()
        .then((contacts) => _presenter.onLoadFriendDataComplete(contacts))
        .catchError((onError) {
      print(onError);
      _presenter.onLoadFriendDataError();
    });
  }
}

class ChatMessageInteractor {
  ChatMessageListPresenter _presenter;
  ChatMessageRepository _repository;

  ChatMessageInteractor(this._presenter){
    _repository = new FirebaseChatMessageRepository();
  }

  void loadMessages(){
    assert(_presenter != null);

    _repository.fetch()
        .then((messages) => _presenter.onLoadChatMessageComplete(messages))
        .catchError((onError) {
      print(onError);
      _presenter.onLoadChatMessageError();
    });
  }

  Future<bool> send({ String text }) async{
    _repository.send(text : text);
    return true;
  }
}