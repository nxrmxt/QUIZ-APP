
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/services.dart';
import 'package:quizapp/shared/shared.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  late User? _user;
  Map<String, dynamic> _userData = {};

  final bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _user = _auth.currentUser;
    if (_user != null) {
      _loadUserData(_user!.uid);
    }
  }

  Future<void> _loadUserData(String userId) async {
    final userDocument = await _usersCollection.doc(userId).get();
    if (userDocument.exists) {
      setState(() {
        _userData = userDocument.data() as Map<String, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var report = Provider.of<Report>(context);


      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(_userData['name'] ?? 'Guest'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(top: 50),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://www.gravatar.com/avatar/placeholder'),
                  ),
                ),
              ),
              Text("Name: ${_userData['name']}" ?? '',
                  style: Theme.of(context).textTheme.headline6),
              Text("Email: ${_userData['email']}" ?? '',
                  style: Theme.of(context).textTheme.subtitle1),
              Text("Phone: ${_userData['phone']}" ?? '',
                  style: Theme.of(context).textTheme.subtitle1),
              Text("College: ${_userData['college']}" ?? '',
                  style: Theme.of(context).textTheme.subtitle1),
              const Spacer(),
              Text('${report.total}',
                  style: Theme.of(context).textTheme.headline2),
              Text('Quizzes Completed',
                  style: Theme.of(context).textTheme.subtitle2),
              const Spacer(),
              ElevatedButton(
                child: const Text('logout'),
                onPressed: () async {
                  AuthService.signOut(context);
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    }
  }

