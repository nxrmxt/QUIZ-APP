import 'package:quizapp/about/about.dart';
import 'package:quizapp/auth_screens/login/sign_up_screen.dart';
import 'package:quizapp/profile/profile.dart';
import 'package:quizapp/topics/topics.dart';
import 'package:quizapp/home/home.dart';

import 'auth_screens/login/login.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LogInScreen(),
  '/signup': (context) => const SignUpScreen(),
  '/topics': (context) => const TopicsScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/about': (context) => const AboutScreen(),
};
