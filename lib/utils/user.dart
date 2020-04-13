import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peeklist/models/friends.dart';
import 'package:peeklist/models/interactions.dart';
import 'package:peeklist/models/requests.dart';
import 'package:peeklist/models/user.dart';
import 'package:peeklist/data/tasks.dart';

class UserService {
  var _db = Firestore.instance.collection('users');

  getUserById(profileId) async {
    return await _db.document(profileId).get();
  }

  updateUserProfile(profileId, displayName, bio) async {
    return await _db.document(profileId).updateData({
      "displayName": displayName,
      "bio": bio,
    });
  }

  sendFriendRequest(String senderId, String receiverId) async {
    DocumentSnapshot senderRef = await getUserById(senderId);
    User sender = User.fromDocument(senderRef);

    DocumentSnapshot receiverRef = await getUserById(receiverId);
    User receiver = User.fromDocument(receiverRef);

    await _db.document(receiver.uid).collection('followRequests').document(sender.uid).setData({
      'user': sender.uid,
      'displayName': sender.displayName,
      'email': sender.email,
      'photoURL': sender.photoURL,
      'received': DateTime.now(),
    });

    await _db.document(sender.uid).collection('sentRequests').document(receiver.uid).setData({
      'user': receiver.uid,
      'displayName': receiver.displayName,
      'email': receiver.email,
      'photoURL': receiver.photoURL,
      'sent': DateTime.now(),
    });
  }

  acceptFriendRequest(userId, Requests req) async {
    DocumentSnapshot senderRef = await getUserById(userId);
    User user = User.fromDocument(senderRef);
    await _db.document(userId).collection('friends').document(req.user).setData({
      'user': req.user,
      'displayName': req.displayName,
      'email': req.email,
      'photoURL': req.photoURL,
      'friendSince': DateTime.now(),
    });
    await _db.document(req.user).collection('friends').document(user.uid).setData({
      'user': user.uid,
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'friendSince': DateTime.now(),
    });
    await _db.document(user.uid).collection('followRequests').document(req.user).delete();
    await _db.document(req.user).collection('sentRequests').document(user.uid).delete();
  }

  declineFriendRequest(userId, Requests req) async {
    await _db.document(userId).collection('followRequests').document(req.user).delete();
    await _db.document(req.user).collection('sentRequests').document(userId).delete();
  }

  checkFriend(userId, friendId) async {
    return await _db.document(userId).collection('friends').document(friendId).get().then((doc) {
      if (doc.exists) {
        return true;
      } else {
        return false;
      }
    });
  }

  checkRequestSent(userId, friendId) async {
    return await _db.document(userId).collection('sentRequests').document(friendId).get().then((doc) {
      if (doc.exists) {
        return true;
      } else {
        return false;
      }
    });
  }

  Stream<List<Requests>> getRequests(uid) {
    return Firestore.instance.collection('users').document(uid).collection('followRequests').snapshots().map((snap) => snap.documents.map((doc) {
      return Requests.fromDocument(doc);
    }).toList());
  }

  Stream<List<Tasks>> getTimeline(uid) {
    return Firestore.instance.collection('users').document(uid).collection('timeline').snapshots().map((snap) => snap.documents.map((doc) {
      return Tasks.fromDocument(doc);
    }).toList());
  }

  Stream<List<Interactions>> getInteractions(uid) {
    return Firestore.instance.collection('users').document(uid).collection('interactions').snapshots().map((snap) => snap.documents.map((doc) {
      return Interactions.fromDocument(doc);
    }).toList());
  }

}