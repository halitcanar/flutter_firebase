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
  
}