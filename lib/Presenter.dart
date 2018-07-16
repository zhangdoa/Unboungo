import 'package:unboungo/Model.dart';
import 'package:unboungo/Interactor.dart';

class FriendListPresenter {
  FriendListInteractor _interactor;
  FriendRepository _repository;

  FriendListPresenter(this._interactor){
    _repository = new RandomUserRepository();
  }

  void loadFriends(){
    assert(_interactor != null);

    _repository.fetch()
        .then((contacts) => _interactor.onLoadFriendDataComplete(contacts))
        .catchError((onError) {
      print(onError);
      _interactor.onLoadFriendDataError();
    });
  }
}