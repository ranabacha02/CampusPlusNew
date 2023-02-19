import '../model/user_model.dart';

class UserController{

  Future<MyUser> getUserById(String userId){
    return MyUser.getUserById(userId);
  }

}
