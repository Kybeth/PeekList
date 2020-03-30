import 'package:flutter_test/flutter_test.dart';
import 'package:peeklist/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

/* Firebase Mock */
class AuthMock extends Mock implements AuthService {}
class FirebaseAuthMock extends Mock implements FirebaseAuth {}
class FirebaseUserMock extends Mock implements FirebaseUser {
  @override
  final String displayName = 'name';
}
class GoogleSignInAccountMock extends Mock implements GoogleSignInAccount {}
class GoogleSignInAuthenticationMock extends Mock
    implements GoogleSignInAuthentication {
  @override
  final String idToken = 'id';
  @override
  final String accessToken = 'secret';
}
class GoogleSignInMock extends Mock implements GoogleSignIn {}

void main() {

  test('Test sample', () {
    final a = 1;
    expect(a, 1);
  });

}