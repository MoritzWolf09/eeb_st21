import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/objects/rental.dart';

class RentalService {

  void createRentalRequest(Rental rental) {
    FirebaseFirestore.instance.collection("rental").add({
      "vehicleId": rental.vehicleId,
      "vehicleDescription": rental.vehicleDescription,
      "renterId": rental.renterId,
      "renterName": rental.renterName,
      "ownerId": rental.ownerId,
      "ownerName": rental.ownerName,
      "rentalStart": rental.rentalStart,
      "status": 0
    });
  }

  Future<QuerySnapshot> readRentalRequestsForUser(userId) async {
    return FirebaseFirestore.instance
        .collection("rental")
        .where("ownerId", isEqualTo: userId)
        .get();
  }

  readRentalRequestsForRenter(String userId) {
    return FirebaseFirestore.instance
        .collection("rental")
        .where("renterId", isEqualTo: userId)
        .get();
  }
}
