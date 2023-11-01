import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizapp/home/home.dart';
import 'package:quizapp/models/user_model.dart';
import '../shared/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../topics/topics.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String? errorMessage;
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text('Log In',
                  style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold

                ),),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      kTextFormField(
                        lable: 'Email',
                        kController: _email,
                        obscure: false,
                        icon: const Icon(Icons.mail),
                        validator: (val) {
                          if (val == null) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      kTextFormField(
                        suffixIcon: IconButton(
                          icon: isVisible
                              ? const Icon(
                                  Icons.remove_red_eye_outlined,
                                  size: 25,
                                  semanticLabel: 'show password',
                                )
                              : const Icon(Icons.visibility_off,
                                  size: 25, semanticLabel: 'Hide password'),
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                        ),
                        lable: 'Password',
                        kController: _password,
                        obscure: isVisible,
                        icon: const Icon(Icons.lock),
                        validator: (val) {
                          if (val == null) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          signIn(
                            _email.text.trim(),
                            _password.text,
                          );
                        },
                        child: const Text('Sign Up'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Divider(

                        ), Text('Other Options'), Divider()],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        
                          InkWell(
                            onTap: () {
                              anonymousSignIn();
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10),
                                  image: const DecorationImage(
                                      image: AssetImage('assets/user.png'),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text("Don't have account")),
                      TextButton(
                          onPressed: () {
                            resetPassword(_email.text.trim());
                          },
                          child: const Text('Forgot Password?')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        _auth.signInWithEmailAndPassword(email: email, password: password).then(
            (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                )));
        // Successfully logged in
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        if (kDebugMode) {
          print(error.code);
        }
      }
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  

  void anonymousSignIn() {
    _auth.signInAnonymously().then((value) => {
          Navigator.pushAndRemoveUntil(
              (context),
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false)
        });
  }
}
