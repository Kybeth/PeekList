const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.onCreateFriend = functions.firestore
    .document("/users/{userId}/friends/{friendId}")
    .onCreate(async (snapshot, context) => {
        console.log("Friend Added", snapshot.data());
        const friend = snapshot.data();
        const userId = context.params.userId;
        const friendId = context.params.friendId;

        const friendTaskRef = admin
            .firestore()
            .collection('pubTasks')
            .where("uid", "==", friendId)
            .where("isprivate", "==", false);

        const timelineTaskRef = admin
            .firestore()
            .collection('users')
            .doc(userId)
            .collection('timeline');

        const friendRef = admin
            .firestore()
            .collection('users')
            .doc(friendId);

        const querySnapshot = await friendTaskRef.get();
        const userSnapshot = await friendRef.get();
        const user = userSnapshot.data();
        querySnapshot.forEach(doc => {
            if (doc.exists) {
                const taskId = doc.id;
                const taskData = doc.data();
                timelineTaskRef.doc(taskId).set({
                    'name': taskData.name,
                    'user': {
                        'uid': taskData.uid,
                        'photoURL': user.photoURL,
                        'displayName': user.displayName,
                    },
                    'comment': taskData.comment,
                    'list': taskData.list,
                    'iscompleted': taskData.iscompleted,
                    'isstarred': taskData.isstarred,
                    'time': taskData.time,
                    'isprivate': taskData.isprivate,
                    'likes': taskData.likes,
                    'create': taskData.create,
                    'uid': taskData.uid,
                });
            }
        });

        admin.firestore()
            .collection('users')
            .doc(userId)
            .collection('interactions')
            .doc()
            .set({
                'type': 'friend',
                'time': Date.now(),
                                //4/20/2020
                                'readed': false,
                                //
                'title': `You are now friends with ${friend.displayName}`,
                'userMeta': {
                    'uid': friendId,
                    'photoURL': friend.photoURL,
                    'displayName': friend.displayName,
                },
                'metaData': {},
            });
    });

exports.onCreateTask = functions.firestore
    .document("/pubTasks/{taskId}")
    .onCreate(async (snapshot, context) => {
        const taskId = context.params.taskId;
        const task = snapshot.data();
        const userId = task.uid;
        console.log(userId);

        const isprivate = task.isprivate;
        console.log(isprivate);
        if (!isprivate) {
            const userRef = admin
                .firestore()
                .collection('users')
                .doc(task.uid);
            const userFriendsRef = admin.firestore()
                .collection('users')
                .doc(userId)
                .collection('friends');
            const userSnapshot = await userRef.get();
            const user = userSnapshot.data();
            admin.firestore()
                .collection('users')
                .doc(task.uid)
                .collection('timeline')
                .doc(taskId)
                .set({
                    'name': task.name,
                    'user': {
                        'uid': task.uid,
                        'photoURL': user.photoURL,
                        'displayName': user.displayName,
                    },
                    'comment': task.comment,
                    'list': task.list,
                    'iscompleted': task.iscompleted,
                    'isstarred': task.isstarred,
                    'time': task.time,
                    'private': task.isprivate,
                    'likes': task.likes,
                    'create': task.create,
                    'uid': task.uid,
                });
            const querySnapshot = await userFriendsRef.get();
            querySnapshot.forEach(doc => {
                const friendId = doc.id;
                admin.firestore()
                    .collection('users')
                    .doc(friendId)
                    .collection('timeline')
                    .doc(taskId)
                    .set({
                        'name': task.name,
                        'user': {
                            'uid': task.uid,
                            'photoURL': user.photoURL,
                            'displayName': user.displayName,
                        },
                        'comment': task.comment,
                        'list': task.list,
                        'iscompleted': task.iscompleted,
                        'isstarred': task.isstarred,
                        'time': task.time,
                        'private': task.isprivate,
                        'likes': task.likes,
                        'create': task.create,
                        'uid': task.uid,
                    });
            });
        }
    });

exports.onUpdateTask = functions.firestore
    .document('/pubTasks/{taskId}')
    .onUpdate(async (change, context) => {
        const taskUpdated = change.after.data();
        const taskId = context.params.taskId;
        if (!taskUpdated.isprivate) {
            const userRef = admin.firestore()
                .collection('users')
                .doc(taskUpdated.uid)
                .collection('friends')

            admin.firestore()
                .collection('users')
                .doc(taskUpdated.uid)
                .collection('timeline')
                .doc(taskId)
                .get().then((doc) => {
                    if (doc.exists) {
                        doc.ref.update(taskUpdated);
                    }
                });

            const querySnapshot = await userRef.get();
            querySnapshot.forEach(doc => {
                const friendId = doc.id;
                admin.firestore()
                    .collection('users')
                    .doc(friendId)
                    .collection('timeline')
                    .doc(taskId)
                    .get().then((doc) => {
                        if (doc.exists) {
                            doc.ref.update(taskUpdated);
                        }
                    });
                });
            }

        if (taskUpdated.isprivate) {
            const userRef = admin.firestore()
                .collection('users')
                .doc(taskUpdated.uid)
                .collection('friends')

            admin.firestore()
                .collection('users')
                .doc(taskUpdated.uid)
                .collection('timeline')
                .doc(taskId)
                .get().then((doc) => {
                    if (doc.exists) {
                        doc.ref.delete();
                    }
                });

            const querySnapshot = await userRef.get();
            querySnapshot.forEach(doc => {
                const friendId = doc.id;
                admin.firestore()
                    .collection('users')
                    .doc(friendId)
                    .collection('timeline')
                    .doc(taskId)
                    .get().then((doc) => {
                        if (doc.exists) {
                            doc.ref.delete();
                        }
                    });
            });
        }

    });

exports.onDeleteTask = functions.firestore
    .document('/pubTasks/{taskId}')
    .onDelete(async (context, snapshot) => {
        const taskToDelete = snapshot.data();
        const taskId = context.params.taskId;
        if (!taskToDelete.isprivate) {
            const userRef = admin.firestore()
                .collection('users')
                .doc(taskToDelete.uid)
                .collection('friends')

            admin.firestore()
                .collection('users')
                .doc(taskToDelete.uid)
                .collection('timeline')
                .doc(taskId)
                .get().then((doc) => {
                    if (doc.exists) {
                        doc.ref.delete();
                    }
                });

            const querySnapshot = await userRef.get();
            querySnapshot.forEach(doc => {
            const friendId = doc.id;
            admin.firestore()
                .collection('users')
                .doc(friendId)
                .collection('timeline')
                .doc(taskId)
                .get().then((doc) => {
                    if (doc.exists) {
                        doc.ref.delete();
                    }
                 });
             });
         }
    });

exports.onReceiveFriendRequest = functions.firestore
    .document('/users/{userId}/followRequests/{friendId}')
    .onCreate(async(snapshot, context) => {
        console.log(snapshot.data());
        const friend = snapshot.data();
        console.log(friend);
        const userId = context.params.userId;
        const friendId = context.params.friendId;
        admin.firestore()
            .collection('users')
            .doc(userId)
            .collection('interactions')
            .doc()
            .set({
                'type': 'request',
                'time': Date.now(),
                                //4/20/2020
                'readed': false,
                                //
                'title': `Friend Request from ${friend.displayName}`,
                'userMeta': {
                    'uid': friendId,
                    'photoURL': friend.photoURL,
                    'displayName': friend.displayName,
                },
                'metaData': {},
            });
    });

exports.onLike = functions.firestore
    .document('/pubTasks/{taskId}/likes/{friendId}')
    .onCreate(async (snapshot, context) => {
        console.log(snapshot.data());
        const res = snapshot.data();
        console.log(res);
        const taskId = context.params.taskId;
        const friendId = context.params.friendId;

        if (res.userMeta.uid !== res.metaData.user.uid) {
                admin.firestore()
                    .collection('users')
                    .doc(res.metaData.user.uid)
                    .collection('interactions')
                    .doc()
                    .set({
                        'type': 'like',
                        'time': Date.now(),
                                        //4/20/2020
                                        'readed': false,
                                        //
                        'title': `${res.userMeta.displayName} liked your task`,
                        'userMeta': {
                            'uid': res.userMeta.uid,
                            'displayName': res.userMeta.displayName,
                            'photoURL': res.userMeta.photoURL,
                        },
                        'metaData': {
                            'taskId': taskId,
                            'taskTitle': res.metaData.taskTitle,
                        }
                    });
        }

    });

exports.onComment = functions.firestore
    .document('/pubTasks/{taskId}/comments/{commentId}')
    .onCreate(async (snapshot, context) => {
        const res = snapshot.data();
        const taskId = context.params.taskId;
        const commentId = context.params.commentId;
        const taskRef = admin.firestore()
            .collection('pubTasks')
            .doc(taskId);

        const taskSnapshot = await taskRef.get();
        const taskData = taskSnapshot.data();
        admin.firestore()
            .collection('users')
            .doc(taskData.uid)
            .collection('interactions')
            .doc()
            .set({
                'type': 'comment',
                'time': Date.now(),
                                //4/20/2020
                                'readed': false,
                                //
                'title': `${res.userMeta.name} replied: ${res.message}`,
                'userMeta': {
                    'displayName': res.userMeta.name,
                    'photoURL': res.userMeta.photoURL,
                    'uid': res.userMeta.uid,
                },
                'metaData': {
                    'taskName': taskData.name,
                    'taskId': taskId,
                    'uid': taskData.uid,
                }
            });
    });

//FCM

exports.notificationFCM = functions.firestore
    .document('/users/{userId}/interactions/{interactionID}')
    .onCreate(async (snapshot, context) => {
        console.log(snapshot.data());
        const interaction = snapshot.data();
        admin.firestore().collection('users').doc(context.params.userId).get().then((doc) => {
          const deviceToken = doc.get('deviceToken');
          console.log(deviceToken)
            var payload = {
              notification: {
                title: interaction.title,
              },
              data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
              },
              tokens: deviceToken
            };
            // Send a message to the device corresponding to the provided
            // registration token.
            admin.messaging().sendMulticast(payload)
              .then((response) => {
                // Response is a message ID string.
                console.log('Successfully sent message:', response);
              })
