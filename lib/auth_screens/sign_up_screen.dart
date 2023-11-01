import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quizapp/home/home.dart';
import 'package:quizapp/models/user_model.dart';
import 'package:quizapp/services/auth.dart';
import '../shared/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _college = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  String? errorMessage;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                'Sign Up Screen',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    kTextFormField(
                      lable: 'Name',
                      kController: _name,
                      obscure: false,
                      icon: const Icon(Icons.person),
                      validator: (val) {
                        if (val == null) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
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
                      lable: 'Phone',
                      kController: _phone,
                      obscure: false,
                      icon: const Icon(Icons.phone),
                      validator: (val) {
                        if (val == null) {
                          return 'Please enter your number';
                        }
                        return null;
                      },
                    ),
                    kTextFormField(
                      lable: 'College',
                      kController: _college,
                      obscure: false,
                      icon: const Icon(Icons.school),
                      validator: (val) {
                        if (val == null) {
                          return 'Please enter your college';
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
                      lable: 'Confirm Password',
                      kController: _confirmPassword,
                      obscure: isVisible,
                      icon: const Icon(Icons.lock),
                      validator: (val) {
                        if (val == null) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                signUp(
                  _email.text,
                  _password.text,
                );
              },
              child: const Text('Sign Up'),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Divider(), Text('Other Options'), Divider()],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    AuthService.signInAnonymously(context);
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
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Already a user'))
          ],
        ),
      )),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
              postDetailsToFirestore();
            })
            .then((value) => {
                  Navigator.pushAndRemoveUntil(
                      (context),
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (route) => false)
                })
            .catchError((e) {
              if (kDebugMode) {
                print(e!.message);
              }
              return e;
            });
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

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = _name.text;
    userModel.college = _college.text;
    userModel.phone = _phone.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
  }
}
