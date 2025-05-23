import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final firebaseAuth = FirebaseAuth.instance;
  // Sign in with email and password
  Future signInAnonymous() async {
    try {
      final result = await firebaseAuth.signInAnonymously();
      print(result.user!.uid);
      return result.user;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign in with email and password
  Future <String>signInWithEmailAndPassword(String email, String password) async {
    String? res;
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      res = "success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          res = "No user found for that email.";
          break;
        case 'wrong-password':
          res = "Wrong password provided for that user.";
          break;
        case 'invalid-email':
          res = "The email address is badly formatted.";
          break;
        case 'user-disabled':
          res = "User with this email has been disabled.";
          break;
        default:
          res = e.message;
          break;
      }
    }
    return res!;
  }

  // Register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Get current user
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  // Check if user is signed in
  bool isLoggedIn() {
    return firebaseAuth.currentUser != null;
  }

  // Get user ID
  String? getUserId() {
    return firebaseAuth.currentUser?.uid;
  }
  
  Future forgotPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return 'Password reset email sent';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future updateUserProfile(String displayName) async {
    try {
      User? user = firebaseAuth.currentUser;
      if (user != null) {
        await user.updateProfile(displayName: displayName);
        await user.reload();
        user = firebaseAuth.currentUser;
        return user;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
  
}