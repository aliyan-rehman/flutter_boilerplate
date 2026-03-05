import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/user_model.dart';

class EmailAuthService {
  // FirebaseAuth instance — we use this to call all auth methods
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SIGN UP — create new account with email and password
  Future<UserModel?> signUp(String email, String password, String name) async {
    try {
      // Create user in Firebase
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await result.user!.updateDisplayName(name);

      // Convert Firebase user → our UserModel and return it
      return UserModel(
        uid: result.user!.uid,
        name: name,
        email: email,
        photoUrl: null,
      );
    } catch (e) {
      // If anything goes wrong, print error and return null
      print('SignUp Error: $e');
      return null;
    }
  }

  // SIGN IN — login with existing email and password
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Convert Firebase user → our UserModel and return it
      return UserModel(
        uid: result.user!.uid,
        name: result.user!.displayName ?? '',
        email: result.user!.email ?? '',
        photoUrl: result.user!.photoURL,
      );
    } catch (e) {
      print('SignIn Error: $e');
      return null;
    }
  }

  // SIGN OUT — logout current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // GET CURRENT USER — check if someone is already logged in
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