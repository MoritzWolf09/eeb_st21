import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/vehicle.dart';

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

  void addVehicle(Vehicle vehicle) {
    FirebaseFirestore.instance.collection("vehicle").add({
      "userId": vehicle.userId,
      "description": vehicle.description,
      "price": vehicle.price,
      "type": vehicle.type
    }
    );
  }
}