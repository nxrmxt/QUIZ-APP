import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  static Future<void> signUpWithEmailPassword(String email, String password,
      String name, String phone, String college, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Push user data to Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'phone': phone,
        'college': college,
      });

      // Navigate to topics screen
      Navigator.pushReplacementNamed(context, '/topics');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);

      // Push user data to Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': userCredential.user!.displayName,
        'email': userCredential.user!.email,
        'phone': '',
        'college': '',
      });

      // Navigate to topics screen
      Navigator.pushReplacementNamed(context, '/topics');
    } catch (e) {
      print(e);
    }
  }

  static Future<void> signInAnonymously(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();

      // Push user data to Firebase
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': 'Anonymous',
        'email': '',
        'phone': '',
        'college': '',
      });

      // Navigate to topics screen
      Navigator.pushReplacementNamed(context, '/topics');
    } catch (e) {
      print(e);
    }
  }

  static void signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to login screen
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print(e);
    }
  }
}
