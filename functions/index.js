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

        const userRef = admin
            .firestore()
            .collection('users')
            .doc(userId);

        const querySnapshot = await friendTaskRef.get();
        const userSnapshot = await userRef.get();
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
                'title': `You are now friends with ${friend.displayName}`,
                'user': {
                    'uid': friendId,
                    'photoURL': friend.photoURL,
                    'displayName': friend.displayName,
                }
            });
    });

exports.onCreateTask = functions.firestore
    .document("/tasks/{taskId}")
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
                    });
            });
        }
    });

exports.onUpdateTask = functions.firestore
    .document('/tasks/{taskId}')
    .onUpdate(async (change, context) => {
        const taskUpdated = change.after.data();
        const taskId = context.params.taskId;
        if (!taskUpdated.isprivate) {
            const userRef = admin.firestore()
                .collection('users')
                .doc(taskUpdated.uid)
                .collection('friends')

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


    });

exports.onDeleteTask = functions.firestore
    .document('/tasks/{taskId}')
    .onDelete(async (context, snapshot) => {
        const taskToDelete = snapshot.data();
        const taskId = context.params.taskId;
        if (!taskUpdated.isprivate) {
            const userRef = admin.firestore()
                .collection('users')
                .doc(taskToDelete.uid)
                .collection('friends')

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
                'title': `Friend Request from ${friend.displayName}`,
                'user': {
                    'uid': friendId,
                    'photoURL': friend.photoURL,
                    'displayName': friend.displayName,
                }
            });
    });