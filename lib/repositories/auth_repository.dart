import 'package:firebase_auth/firebase_auth.dart';

import '../constants/firebase_constants.dart';
import 'handle_exception.dart';

class AuthRepository {
  User? get currentUser => fbAuth.currentUser;

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      fbAuth.setLanguageCode('ko');
      print('1signup: {$name}, {$email}, {$password}');
      final userCredential = await fbAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('2signup: {$name}, {$email}, {$password}');
      final signedInUser = userCredential.user!;
      print('3signup: {$name}, {$email}, {$password}');
      await usersCollection.doc(signedInUser.uid).set({
        'name': name,
        'email': email,
      });
      print('4signup: {$name}, {$email}, {$password}');
    } on FirebaseAuthException catch (e) {
      // 에러 처리
      if (e.code == 'weak-password') {
        print('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('The email address is not valid.');
      } else {
        print('Error: ${e.message}');
      }
    }  catch (e) {
      print('6signup: {$name}, {$email}, {$password}');
      print('Error: ${e.toString()}');

      throw handleException(e);
    }
  }

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      await fbAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> signout() async {
    try {
      await fbAuth.signOut();
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> changePassword(String password) async {
    try {
      await currentUser!.updatePassword(password);
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await fbAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await currentUser!.sendEmailVerification();
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> reloadUser() async {
    try {
      await currentUser!.reload();
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> reauthenticateWithCredential(
    String email,
    String password,
  ) async {
    try {
      await currentUser!.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
    } catch (e) {
      throw handleException(e);
    }
  }
}
