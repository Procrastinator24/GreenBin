
import 'package:flutter_application_3/features/user/data/models/user_model.dart';

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
  final String? newName;
  final String? newEmail;
  final String? newPhone;
  final String? newAdress;

  UpdateUserProfileEvent({required this.userId, this.newName, this.newAdress, this.newEmail, this.newPhone});
}

class UserLoggedOut extends UserEvent {}

class UserUpdatedEvent extends UserEvent {
  final UserModel user;
  UserUpdatedEvent(this.user);
}