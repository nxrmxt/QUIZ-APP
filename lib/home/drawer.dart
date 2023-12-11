import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Function to fetch data from the "subject" collection

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future<List<Map<String, dynamic>>> fetchSubjects() async {
    List<Map<String, dynamic>> subjects = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('subject').get();

      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;
        if (data != null) {
          subjects.add(data);
        }
      });
    } catch (e) {
      print('Error fetching subjects: $e');
    }

    return subjects;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        const DrawerHeader(
          child: Text('Subjects'),
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchSubjects(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data![index]['subject']),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    ));
  }
}
