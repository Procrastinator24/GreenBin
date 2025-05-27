import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? adress;
  final DateTime createdAt;
  UserModel(
    {
      required this.uid,
      required this.name,
      required this.email,
      required this.createdAt,
      this.phone,
      this.adress,
    }
  );

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? adress,
  }){
    return UserModel(
      uid: uid, 
      name: name ?? this.name, 
      email: email ?? this.email,
      phone: phone ?? this.phone,
      adress: adress ?? this.adress, 
      createdAt: createdAt);
  }
  factory UserModel.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot.id,
      email: data['email'] ?? '',
      name: data['name'] ?? 'No name',
      phone: data['phone'] ?? 'No phone',
      adress: data['adress'] ?? 'No adress',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      adress: json['adress'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),

    );
  }

  Map<String, dynamic> toJson(){
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'adress': adress,
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