import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_3/screens/userScreens/BloC/auth_bloc.dart';
import 'package:flutter_application_3/screens/userScreens/BloC/event.dart';
import 'package:flutter_application_3/screens/userScreens/BloC/state.dart';
import 'package:flutter_application_3/services/get_user_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _userSubscription;
  StreamSubscription? _authSubscription;

  UserBloc({required AuthBloc authBloc}) :super(UserInitial()){

    _authSubscription = authBloc.stream.listen((authState) {
      if (authState is AuthAuthenticated) {
        add(LoadUserEvent(authState.userId));
      } else {
        _userSubscription?.cancel();
        emit(UserInitial());
      }
    });
    on<LoadUserEvent>(_loadUser);
    on<UpdateUserNameEvent>(_updateName);
  }

  Future<void> _loadUser(LoadUserEvent event, Emitter<UserState> emit) async {
     emit(UserLoading());
    _userSubscription?.cancel(); // Отменяем предыдущую подписку

    _userSubscription = _firestore
        .collection('users')
        .doc(event.userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final user = UserModel.fromFirestore(snapshot);
        emit(UserLoaded(user));
      } else {
        emit(UserError('User not found'));
      }
    }, onError: (e) {
      emit(UserError('Failed to load user'));
    });
  }

  Future<void> _updateName(UpdateUserNameEvent event, Emitter<UserState> emit) async {
    try {
      await _firestore.collection('users').doc(event.userId).update({
        'name': event.newName,
        'updateAt': FieldValue.serverTimestamp(),
      });
    }catch (e) {
      emit(UserError('Failed to update name'));
    }
  }
  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}