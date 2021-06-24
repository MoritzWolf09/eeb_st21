import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<QuerySnapshot> readUserInformation(userId) async {
    return FirebaseFirestore.instance
        .collection("user")
        .where("userId", isEqualTo: userId)
        .get();
  }
  Future<QuerySnapshot> addUserInformation(userId, name, surname, nickname) async {
    FirebaseFirestore.instance.collection("user").add({
      "userId": userId,
      "name": name,
      "surname": surname,
      "nickname": nickname
    });
  }
}
