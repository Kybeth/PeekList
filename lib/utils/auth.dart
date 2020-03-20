import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();
  // PublishSubject isAuth = PublishSubject();
  // bool isAuth = false;
  // Observable<Map<bool, dynamic>> isAuth;

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);
    profile = user.switchMap((FirebaseUser u) {
      if (u != null) {
        return _db.collection('users').document(u.uid).snapshots().map((snap) => snap.data);
      } else {
        return Observable.just({ });
      }
    });

  }

  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken
    );
    FirebaseUser user = await _auth.signInWithCredential(credential);
    updateUserData(user);
    print("Signed In: " + user.displayName);
    loading.add(false);
    // isAuth = true as Observable<Map<bool, dynamic>>;
    // isAuth.add(true);
    return user;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now(),
      'bio': "",
      'tasks': ['inbox'],
    }, merge: true);

  }

  void signOut() {
    _auth.signOut();
    // isAuth.add(false);
  }

  Future userID() async{
  final FirebaseUser user = await _auth.currentUser();
  return user.uid;
  }


}

final AuthService authService = AuthService();