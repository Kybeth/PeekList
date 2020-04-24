import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peeklist/models/interactions.dart';
import 'package:peeklist/models/requests.dart';
import 'package:peeklist/models/social_model.dart';
import 'package:peeklist/models/user.dart';

import '../models/friends.dart';

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

  updateToken(profileId, deviceToken) async {
    return await _db.document(profileId).updateData({
      "deviceToken": deviceToken,
    });
  }

  Stream<List<Requests>> getRequests(uid) {
    return _db.document(uid).collection('followRequests').orderBy("received").snapshots().map((snap) => snap.documents.map((doc) {
      return Requests.fromDocument(doc);
    }).toList());
  }

  Stream<List<SocialModel>> getTimeline(uid) {
    return _db.document(uid).collection('timeline').orderBy("create", descending: true).snapshots().map((snap) => snap.documents.map((doc) {
      return SocialModel.fromDocument(doc);
    }).toList());
  }

  Stream<List<SocialModel>> getUserTimeline(uid) {
    return _db.document(uid).collection('timeline').where('uid', isEqualTo: uid).snapshots().map((snap) => snap.documents.map((doc) {
      return SocialModel.fromDocument(doc);
    }).toList());
  }

  Stream<List<Interactions>> getInteractions(uid) {
    return _db.document(uid).collection('interactions').snapshots().map((snap) => snap.documents.map((doc) {
      return Interactions.fromDocument(doc);
    }).toList());
  }

  Stream<List<Friends>> getFriends(uid) {
    return _db.document(uid).collection('friends').snapshots().map((snap) => snap.documents.map((doc) {
      return Friends.fromDocument(doc);
    }).toList());
  }

 void updateIntertions(uid)async{
    await _db.document(uid).updateData({'newnoti':false});
  }
}

final UserService userService = UserService();