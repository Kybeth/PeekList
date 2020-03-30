import 'package:cloud_firestore/cloud_firestore.dart';


class UserService {
  var _db = Firestore.instance.collection('users');
  // DocumentReference userRef = _db.collection('users')
  getUserById(profileId) {
    return _db.document(profileId).get();
  }

  updateUserProfile(profileId, displayName, bio) {
    _db.document(profileId).updateData({
      "displayName": displayName,
      "bio": bio,
    });
  }
}