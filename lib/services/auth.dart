import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

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
