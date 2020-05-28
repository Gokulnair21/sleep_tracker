import 'dart:async';
//my imports
import 'package:sleep_tracker/HelperFiles/user_info_helper_class.dart';
import 'package:sleep_tracker/model/user_info_model.dart';


class UserInfoBloc {
  UserInfoBloc() {
    getUserInfo();
  }

  final _userController = StreamController<List<User>>.broadcast();

  get user => _userController.stream;

  dispose() {
    _userController.close();
  }

  getUserInfo() async {
    _userController.sink.add(await UserInfoDatabaseHelper.db.getAllUserInfo());
  }


  add(User user) {
    UserInfoDatabaseHelper.db.insertUserInfo(user);
    getUserInfo();
  }

  getOnlyUserInfo(int id)
  {
    UserInfoDatabaseHelper.db.getUserInfo(id);
  }

  update(User user)
  {
    UserInfoDatabaseHelper.db.updateUserInfo(user);
    getUserInfo();
  }


}
final userInfoBloc=UserInfoBloc();
