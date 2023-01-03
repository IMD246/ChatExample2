import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthProvider {
  static FirebaseAuthProvider? instance = FirebaseAuthProvider._();

  FirebaseAuthProvider._();

  factory FirebaseAuthProvider.getInstance() {
    instance ??= FirebaseAuthProvider._();
    return instance!;
  }

  final FirebaseAuth _authUser = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> logout() async {
    final user = currentUser;
    if (user != null) {
      await _authUser.signOut();
      await _googleSignIn.signOut();
    }
  }

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignAuth =
        await googleSignInAccount?.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignAuth!.accessToken,
      idToken: googleSignAuth.idToken,
    );
    await _authUser.signInWithCredential(authCredential);
    final user = currentUser;
    return user;
  }

  User? get currentUser {
    final User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user : null;
  }
}
