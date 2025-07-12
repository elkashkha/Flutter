import 'user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}
class UserSessionExpired extends UserState {}

class UserNotLoggedIn extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}
class UserUpdated extends UserState {}

class UserFailure extends UserState {
  final String error;
  UserFailure(this.error);
}
