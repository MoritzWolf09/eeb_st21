import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleService {
  Future<QuerySnapshot> readVehicleOfUser(userId) async {
    return FirebaseFirestore.instance
        .collection("vehicle")
        .where("userId", isEqualTo: userId)
        .get();
  }

  Future<QuerySnapshot> readVehicles() async {
    return FirebaseFirestore.instance
        .collection("vehicle")
        .get();
  }
}
