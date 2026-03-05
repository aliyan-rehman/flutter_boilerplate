import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../models/user_model.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // GOOGLE SIGN IN
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Step 1 — Open Google account picker popup
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If user cancelled the popup, return null
      if (googleUser == null) return null;

      // Step 2 — Get auth details from Google
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Step 3 — Create Firebase credential using Google tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Step 4 — Sign in to Firebase with that credential
      UserCredential result = await _auth.signInWithCredential(credential);

      // Step 5 — Convert to our UserModel and return
      return UserModel(
        uid: result.user!.uid,
        name: result.user!.displayName ?? '',
        email: result.user!.email ?? '',
        photoUrl: result.user!.photoURL,
      );
    } catch (e) {
      print('Google SignIn Error: $e');
      return null;
    }
  }

  // SIGN OUT — signs out from both Google and Firebase
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // GET CURRENT USER — check if someone already logged in
  UserModel? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;

    return UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
  }
}