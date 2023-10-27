class CourseModel {
  String courseName;
  String courseCode;
  String courseDescription;
  int year;
  int semester;

  CourseModel({
    required this.courseName,
    required this.courseCode,
    required this.courseDescription,
    required this.year,
    required this.semester,
  });

  factory CourseModel.fromMap(map) {
    return CourseModel(
      courseName: map['courseName'],
      courseCode: map['courseCode'],
      courseDescription: map['courseDescription'],
      year: map['year'],
      semester: map['semester'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseName': courseName,
      'courseCode': courseCode,
      'courseDescription': courseDescription,
      'year': year,
      'semester': semester,
    };
  }

  Map<String, Object?> toJson() => {
        'courseName': courseName,
        'courseCode': courseCode,
        'courseDescription': courseDescription,
        'year': year,
        'semester': semester,
      };

  CourseModel copy({
    String? courseName,
    String? courseCode,
    String? courseDescription,
    int? year,
    int? semester,
  }) =>
      CourseModel(
        courseName: courseName ?? this.courseName,
        courseCode: courseCode ?? this.courseCode,
        courseDescription: courseDescription ?? this.courseDescription,
        year: year ?? this.year,
        semester: semester ?? this.semester,
      );
}
