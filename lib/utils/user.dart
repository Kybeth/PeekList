import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peeklist/models/user.dart';


class UserService {
  var _db = Firestore.instance.collection('users');
  // DocumentReference userRef = _db.collection('users')
  getUserById(profileId) async {
    return await _db.document(profileId).get();
  }

  updateUserProfile(profileId, displayName, bio) async {
    return await _db.document(profileId).updateData({
      "displayName": displayName,
      "bio": bio,
    });
  }

  sendFriendRequest(String senderId, User receiver) async {
    DocumentSnapshot senderRef = await getUserById(senderId);
    User sender = User.fromDocument(senderRef);
    await _db.document(sender.uid).collection('followRequests').document().setData({
      'type': 'sent',
      'user': receiver.uid,
      'displayName': receiver.displayName,
      'email': receiver.email,
      'photoURL': receiver.photoURL,
    });

    await _db.document(receiver.uid).collection('followRequests').document().setData({
      'type': 'received',
      'user': sender.uid,
      'displayName': sender.displayName,
      'email': sender.email,
      'photoURL': sender.photoURL,
    });
  }

  getRequests(uid) async {
    return await _db.document(uid).collection('followRequests').getDocuments();
  }

}