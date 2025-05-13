import 'package:flutter_application_3/services/get_user_data.dart';

abstract class UserEvent {}

class LoadUserEvent extends UserEvent {
  final String userId;
  LoadUserEvent(this.userId);
}

class UpdateUserNameEvent extends UserEvent {
  final String userId;
  final String newName;
  UpdateUserNameEvent(this.userId, this.newName);
}

class UpdateUserProfileEvent extends UserEvent {
  final String userId;
  final String newName;
  UpdateUserProfileEvent(this.userId, this.newName);
}

class UserLoggedOut extends UserEvent {}

class UserUpdatedEvent extends UserEvent {
  final UserModel user;
  UserUpdatedEvent(this.user);
}