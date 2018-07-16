import 'package:unboungo/Model.dart';

abstract class FriendListInteractor {
  void onLoadFriendDataComplete(List<FriendData> items);
  void onLoadFriendDataError();
}