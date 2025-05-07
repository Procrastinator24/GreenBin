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
