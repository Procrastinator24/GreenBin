import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final DateTime createdAt;
  UserModel(
    {
      required this.uid,
      required this.name,
      required this.email,
      required this.createdAt,
    }
  );


  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return UserModel(
      uid: snapshot.id,
      email: data['email'] ?? '',
      name: data['name'] ?? 'No name',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),

    );
  }

  Map<String, dynamic> toJson(){
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
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