import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizapp/shared/bottom_nav.dart';
import '../topics/topics.dart';

class HomeScreen extends StatefulWidget {
  final String? courseCode;

  const HomeScreen({Key? key, this.courseCode}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedSubject = ''; // Track the selected subject

  // Function to load subjects from Firestore
  Future<List<String>> loadSubjects() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('subject').get();

    List<String> subjects = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      subjects.add(doc['name']);
    }
    return subjects;
  }

  // Function to load courses based on the selected subject
  Future<List<String>> loadCourses(String subject) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .where('courseTopic', isEqualTo: subject)
        .get();

    List<String> courses = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      courses.add(doc['courseCode']);
    }
    return courses;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double pad = 20;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                FontAwesomeIcons.circleUser,
                color: Colors.pink[200],
              ),
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
            // Button to show subjects in drawer
            IconButton(
              icon: Icon(
                FontAwesomeIcons.listAlt,
                color: Colors.white,
              ),
              onPressed: () async {
                List<String> subjects = await loadSubjects();

                // Show subjects in a drawer
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text('All Subjects'),
                          onTap: () {
                            setState(() {
                              selectedSubject = '';
                              Navigator.pop(context);
                            });
                          },
                        ),
                        for (String subject in subjects)
                          ListTile(
                            title: Text(subject),
                            onTap: () {
                              setState(() {
                                selectedSubject = subject;
                                Navigator.pop(context);
                              });
                            },
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: FutureBuilder<List<String>>(
            future: loadSubjects(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text("Error loading subjects: ${snapshot.error}"),
                );
              }

              List<String> subjects = snapshot.data ?? [];

              return ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(subjects[index]),
                    onTap: () {
                      setState(() {
                        selectedSubject = subjects[index];
                        Navigator.pop(context);
                      });
                    },
                  );
                },
              );
            },
          ),
        ),
        body: StreamBuilder(
          stream: selectedSubject.isEmpty
              ? FirebaseFirestore.instance.collection('courses').snapshots()
              : FirebaseFirestore.instance
              .collection('courses')
              .where('courseTopic', isEqualTo: selectedSubject)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error loading data: ${snapshot.error}"),
              );
            }

            List<DocumentSnapshot> courses = snapshot.data!.docs;

            if (courses.isEmpty) {
              return Center(
                child: Text(
                  "No courses found for the selected subject.",
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                var course = courses[index].data() as Map<String, dynamic>;
                var courseCode = course['courseCode'];
                var courseImage = course['img'];

                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(pad),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => TopicsScreen(
                                courseCode: courseCode,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: size.height / 3,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Image.network(
                                  courseImage,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: Text(
                                  courseCode,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                  ],
                );
              },
            );
          },
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}
