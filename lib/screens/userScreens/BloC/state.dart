import 'package:flutter_application_3/services/get_user_data.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}

class UserUpdated extends UserState {
  final UserModel user;
  UserUpdated(this.user);
}
class UserError extends UserState {
  final String message;

  UserError(this.message);
}