import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peeklist/models/social_model.dart';

class TaskService {
  var _db = Firestore.instance.collection('pubTasks');

  likeTask(SocialModel tasks, Map likes) async {
    await _db.document(tasks.taskId).updateData({
      'likes': likes,
    });
  }
}