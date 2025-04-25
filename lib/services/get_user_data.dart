import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  
  UserModel(
    {
      required this.uid,
      required this.name,
      required this.email
    }
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }
}

class UserService {

  final _userRef = FirebaseFirestore.instance.collection('users');

  //Получить пользователя по uid
  Future<UserModel?> getUser(String uid) async {
    final doc = await _userRef.doc(uid).get();

    if (doc.exists){
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  //Сохраняем пользователя
  Future<void> saveUser(UserModel user) async {
    await _userRef.doc(user.uid).set(user.toJson());
  }
}