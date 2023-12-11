import 'package:quizapp/about/about.dart';
import 'package:quizapp/auth_screens/sign_up_screen.dart';
import 'package:quizapp/profile/profile.dart';
import 'package:quizapp/home/home.dart';

import 'auth_screens/login.dart';

var appRoutes = {
  '/': (context) =>  HomeScreen(),
  '/login': (context) => const LogInScreen(),
  '/signup': (context) => const SignUpScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/about': (context) => const AboutScreen(),
};
