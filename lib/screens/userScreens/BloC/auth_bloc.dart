import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthEvent {}
class AuthCheckRequested extends AuthEvent {}
class AuthLogout extends AuthEvent {}

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthAuthenticated extends AuthState {
  final String userId;
  AuthAuthenticated(this.userId);
}

class AuthUnauthenticated extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheck);
    on<AuthLogout>(_onLogout);
  }

  Future<void> _onAuthCheck(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final user = _auth.currentUser;
    user != null
      ? emit(AuthAuthenticated(user.uid))
      : emit(AuthUnauthenticated());
  }

  Future<void> _onLogout(AuthLogout event, Emitter<AuthState> emit) async {
    await _auth.signOut();
    emit(AuthUnauthenticated());

  }
}