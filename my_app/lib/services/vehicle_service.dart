import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/objects/vehicle.dart';

class VehicleService {
  Future<QuerySnapshot> readVehicleOfUser(userId) async {
    return FirebaseFirestore.instance
        .collection("vehicle")
        .where("userId", isEqualTo: userId)
        .get();
  }

  Future<QuerySnapshot> readVehicles(String userId) async {
    return FirebaseFirestore.instance
        .collection("vehicle")
        .where("userId", isNotEqualTo: userId)
        .get();
  }

  void addVehicle(Vehicle vehicle) {
    FirebaseFirestore.instance.collection("vehicle").add({
      "userId": vehicle.userId,
      "description": vehicle.description,
      "price": vehicle.price,
      "type": vehicle.type
    });
  }

  void changeVehicle(Vehicle vehicle) {
    FirebaseFirestore.instance.collection("vehicle").doc(vehicle.id).update({
      "description": vehicle.description,
      "price": vehicle.price,
      "type": vehicle.type
    });
  }

  Future<DocumentSnapshot> readVehicle(String id) {
    return FirebaseFirestore.instance.collection("vehicle").doc(id).get();
  }
}
