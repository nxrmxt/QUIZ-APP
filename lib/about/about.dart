import 'package:flutter/material.dart';

import '../shared/bottom_nav.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('about'), backgroundColor: Colors.blue),
      body: const Center(
        child: Text('About this app...'),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
