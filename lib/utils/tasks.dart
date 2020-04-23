import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peeklist/models/comments.dart';
import 'package:peeklist/models/likes.dart';
import 'package:peeklist/models/social_model.dart';
import 'package:peeklist/models/user.dart';
import 'package:peeklist/utils/user.dart';

class TaskService {
  var _dbTasks = Firestore.instance.collection('pubTasks');

  likeTask(String uid, SocialModel tasks, Map likes) async {
    DocumentSnapshot userRef = await userService.getUserById(uid);
    User user = User.fromDocument(userRef);
    await _dbTasks.document(tasks.taskId).updateData({
      'likes': likes,
    });
    await _dbTasks.document(tasks.taskId).collection("likes").document(user.uid).setData({
      'title': '${user.displayName} liked your task',
      'userMeta': {
        'photoURL': user.photoURL,
        'displayName': user.displayName,
        'uid': user.uid,
      },
      'metaData': {
        'taskTitle': tasks.name,
        'create': tasks.create,
        'iscompleted': tasks.iscompleted,
        'isprivate': tasks.isprivate,
        'user': tasks.user,
      }
    });
  }

  unlikeTask(String uid, SocialModel tasks, Map likes) async {
    await _dbTasks.document(tasks.taskId).updateData({
      'likes': likes,
    });
    await _dbTasks.document(tasks.taskId).collection('likes').document(uid).delete();
  }

  uploadComment(String taskId, String uid, String message) async {
    DocumentSnapshot userRef = await userService.getUserById(uid);
    User user = User.fromDocument(userRef);
    await _dbTasks.document(taskId).collection('comments').document().setData({
      'message': message,
      'userMeta': {
        'name': user.displayName,
        'photoURL': user.photoURL,
        'uid': user.uid,
      },
      'posted': Timestamp.now(),
    });
  }

  Stream<List<Comments>> getComments(String taskId) {
    return _dbTasks.document(taskId).collection('comments').orderBy("posted").snapshots().map((snap) => snap.documents.map((doc) {
      return Comments.fromDocument(doc);
    }).toList());
  }

  Stream<List<Likes>> getLikes(String taskId) {
    return _dbTasks.document(taskId).collection('likes').snapshots().map((snap) => snap.documents.map((doc) {
      return Likes.fromDocument(doc);
    }).toList());
  }

}

final TaskService taskService = TaskService();