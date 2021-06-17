import 'package:cloud_firestore/cloud_firestore.dart';

class RatingService {
  Future<QuerySnapshot> readVehicleOfUser(userId) async {
    return FirebaseFirestore.instance
        .collection("rating")
        .where("userId", isEqualTo: userId)
        .get();
  }
}
