import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<QuerySnapshot> readUserInformation(userId) async {
    return FirebaseFirestore.instance
        .collection("user")
        .where("userId", isEqualTo: userId)
        .get();
  }
}
