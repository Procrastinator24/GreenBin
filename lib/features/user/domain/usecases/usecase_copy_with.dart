// import 'package:flutter_application_3/features/user/data/models/user_model.dart';

// class UpdatedUserProfileUserCase{
//   final IUserRepository repository;

//   UpdatedUserProfileUserCase(this.repository);

//   Future<void> call(String userId, String newName) async{

//     final user = await repository.getUser(userId);
//     final updatedUser = user.copyWith(name: newName);
//     await repository.updatedUser(updatedUser);
//   }
// }