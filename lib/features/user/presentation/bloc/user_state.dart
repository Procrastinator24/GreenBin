
import 'package:flutter_application_3/features/user/data/models/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}

class UserUpdating extends UserState {}

class UserUpdateSuccess extends UserState{

}

class UserUpdateFailure extends UserState{
  final String message;

  UserUpdateFailure(this.message);
}


class UserError extends UserState {
  final String message;

  UserError(this.message);
}
