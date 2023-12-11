class SubjectModel {
  String subjectName;
  List<String> courses = [];
  SubjectModel({
    required this.subjectName,
    required this.courses,
  });

  SubjectModel copy({
    String? subjectName,
    List<String>? courses,
  }) {
    return SubjectModel(
      subjectName: subjectName ?? this.subjectName,
      courses: courses ?? this.courses,
    );
  }

  factory SubjectModel.fromMap(map) {
    return SubjectModel(
      subjectName: map["subjectName"],
      courses: map["courses"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subjectName': subjectName,
      'courses': courses,
    };
  }

  static SubjectModel fromJson(Map<String, dynamic> json) => SubjectModel(
        subjectName: json[SubjectFields.subjectName],
        courses: json[SubjectFields.courses],
      );
}

class SubjectFields {
  static const String subjectName = 'subjectName';
  static const String courses = 'courses';
}
