import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  String? courseCode;
  String? courseTopic;
  String? img;
  CourseModel({this.img, this.courseCode, this.courseTopic});

  factory CourseModel.fromMap(map) => CourseModel(
        courseCode: map["courseCode"],
        courseTopic: map["courseTopic"],
        img: map["img"],
      );

  Map<String, dynamic> toMap() => {
        "courseCode": courseCode,
        "courseTopic": courseTopic,
        "img": img,
      };
  



  CourseModel.fromSnapshot(DocumentSnapshot snapshot)
      : courseCode = snapshot[CourseFields.courseCode],
        courseTopic = snapshot[CourseFields.courseTopic],
        img = snapshot[CourseFields.img];


        
  CourseModel copy({
    String? courseCode,
    String? courseTopic,
    String? img,
  }) {
    return CourseModel(
      courseCode: courseCode ?? this.courseCode,
      courseTopic: courseTopic ?? this.courseTopic,
      img: img ?? this.img,
    );
  }

  static CourseModel fromJson(Map<String, dynamic> json) => CourseModel(
        courseCode: json[CourseFields.courseCode],
        courseTopic: json[CourseFields.courseTopic],
        img: json[CourseFields.img],
      );



    
}

class CourseFields {
  static const String courseCode = 'courseCode';
  static const String courseTopic = 'courseTopic';
  static const String img = 'img';
}
