import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

  // Gets Avatar URL for the userId form Firebase Storage
  Future<String> getAvatarUrl(userId) async {
    String downloadURL = await FirebaseStorage.instance
        .ref('users/' + userId + '.png')
        .getDownloadURL();

    return downloadURL;
  }

  // Gets Vehicle URL for the userId form Firebase Storage
  Future<String> getVehicleUrl(vehicleId) async {
    String downloadURL = await FirebaseStorage.instance
        .ref('vehicle/' + vehicleId + '.jpg')
        .getDownloadURL();

    return downloadURL;
  }
}