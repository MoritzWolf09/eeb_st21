import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

  Future<String> getAvatarUrl(userId) async {
    String downloadURL = await FirebaseStorage.instance
        .ref('users/' + userId + '.png')
        .getDownloadURL();

    return downloadURL;
  }
}