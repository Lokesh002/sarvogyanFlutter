import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseNetworking {
  String email;
  String password;
  String phoneNo;
  String otp;

  Future loginUserThroughEmail(
      String email, String password, BuildContext context) async {
    try {
      Future<bool> verified;

      FirebaseAuth _auth = FirebaseAuth.instance;
      AuthResult authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = authResult.user;
      return user.getIdToken();
    } on AuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
