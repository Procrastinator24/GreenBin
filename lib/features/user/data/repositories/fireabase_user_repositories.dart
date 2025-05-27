import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_3/features/user/data/models/user_model.dart';

class FireabaseUserRepositories {
  final FirebaseFirestore _firestore;

  FireabaseUserRepositories(this._firestore);

  Future<UserModel> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) throw Exception("User not found");
    return UserModel.fromJson(doc.data()!..['id'] = doc.id);
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }
}