import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peeklist/models/comments.dart';
import 'package:peeklist/models/social_model.dart';
import 'package:peeklist/models/user.dart';
import 'package:peeklist/utils/user.dart';

class TaskService {
  var _dbTasks = Firestore.instance.collection('pubTasks');

  likeTask(SocialModel tasks, Map likes) async {
    await _dbTasks.document(tasks.taskId).updateData({
      'likes': likes,
    });
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
    return _dbTasks.document(taskId).collection('comments').snapshots().map((snap) => snap.documents.map((doc) {
      return Comments.fromDocument(doc);
    }).toList());
  }
}

final TaskService taskService = TaskService();