import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/userScreens/BloC/auth_bloc.dart';
import 'package:flutter_application_3/screens/userScreens/BloC/event.dart';
import 'package:flutter_application_3/screens/userScreens/BloC/state.dart';
import 'package:flutter_application_3/services/get_user_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseFirestore _firestore;
  StreamSubscription<DocumentSnapshot>? _userSubscription;
  StreamSubscription? _authSubscription;
  bool _isHandlerActive = false;

  UserBloc({required AuthBloc authBloc, FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance, super(UserInitial()) {
    // Подписка на изменения аутентификации
    _authSubscription = authBloc.stream.listen((authState) {
      if (authState is AuthAuthenticated) {
        add(LoadUserEvent(authState.userId));
      } else {
        _userSubscription?.cancel();
        add(UserLoggedOut());
      }
    });

    // Обработчики событий
    on<LoadUserEvent>(_loadUser);
    on<UpdateUserNameEvent>(_updateName);
    on<UpdateUserProfileEvent>(_updateProfile);
    on<UserLoggedOut>(_UserLoggedOut);
    on<UserUpdatedEvent>((event, emit) {
      emit(UserLoaded(event.user));
    });
    // on<UpdateUserDataEvent>(_updateUserData); // Новый обработчик для общих данных
  }

  // Загрузка данных пользователя
  Future<void> _loadUser(LoadUserEvent event, Emitter<UserState> emit) async {
  emit(UserLoading());
  await _userSubscription?.cancel();

  _userSubscription = _firestore
      .collection('users')
      .doc(event.userId)
      .snapshots()
      .listen(
        (snapshot) => _handleSnapshot(snapshot, emit),
        onError: (error) => _handleError(error, emit),
      );
  }
  void _handleSnapshot(DocumentSnapshot snapshot, Emitter<UserState> emit) {
  try {
    if (!snapshot.exists) {
      emit(UserError('User not found'));
      return;
    }

    final user = UserModel.fromFirestore(snapshot);
    print('Получен пользователь: ${user.name}');
    add(UserUpdatedEvent(user));
  } catch (e) {
    emit(UserError('Ошибка обработки данных: ${e.toString()}'));
  }
}
  void _handleError(dynamic error, Emitter<UserState> emit) {
    if (!_isHandlerActive) return;
    emit(UserError(error.toString()));
  }
  // Обновление имени
  Future<void> _updateName(UpdateUserNameEvent event, Emitter<UserState> emit) async {
    try {
      await _firestore.collection('users').doc(event.userId).update({
        'name': event.newName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      // Состояние автоматически обновится через snapshots()
    } catch (e) {
      emit(UserError('Failed to update name: ${e.toString()}'));
      rethrow;
    }
  }

  Future<void> _updateProfile(UpdateUserProfileEvent event, Emitter<UserState> emit) async {
    if (state is! UserLoaded) return;

    try {
      await _firestore.collection('users').doc(event.userId).update({
        'name': event.newName,
        // 'photoUrl': event.newPhotoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _handleError(e, emit);
    }
  }
  void _UserLoggedOut(UserLoggedOut event, Emitter<UserState> emit) {
    emit(UserInitial());
  }
  // Обновление фото (новый метод)
  // Future<void> _updatePhoto(UpdateUserPhotoEvent event, Emitter<UserState> emit) async {
  //   try {
  //     await _firestore.collection('users').doc(event.userId).update({
  //       'photoUrl': event.newPhotoUrl,
  //       'updatedAt': FieldValue.serverTimestamp(),
  //     });
  //   } catch (e) {
  //     emit(UserError('Failed to update photo: ${e.toString()}'));
  //     rethrow;
  //   }
  // }

  // Общее обновление данных (новый метод)
  // Future<void> _updateUserData(UpdateUserDataEvent event, Emitter<UserState> emit) async {
  //   try {
  //     await _firestore.collection('users').doc(event.userId).update({
  //       ...event.updatedFields,
  //       'updatedAt': FieldValue.serverTimestamp(),
  //     });
  //   } catch (e) {
  //     emit(UserError('Failed to update user data: ${e.toString()}'));
  //     rethrow;
  //   }
  // }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
  
  // Вспомогательный метод для быстрого доступа к данным в UI
  static UserModel? currentUser(BuildContext context) {
    final state = context.read<UserBloc>().state;
    return state is UserLoaded ? state.user : null;
  }
}
