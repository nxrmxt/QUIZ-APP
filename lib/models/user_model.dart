const String tableUser = 'user';

class userFields {
  static final List<String> values = [uid, email, name, college, phone];

  static const String uid = 'uid';
  static const String email = 'email';
  static const String name = 'name';
  static const String college = 'college';
  static const String phone = 'phone';
}

class UserModel {
  String? uid;
  String? email;
  String? name;
  String? college;
  String? phone;

  UserModel({this.uid, this.email, this.name, this.college, this.phone});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      college: map['college'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'college': college,
      'phone': phone,
    };
  }

  Map<String, Object?> toJson() => {
        userFields.uid: uid,
        userFields.email: email,
        userFields.name: name,
        userFields.college: college,
        userFields.phone: phone
      };

  UserModel copy({
    String? uid,
    String? email,
    String? name,
    String? college,
    String? phone,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        name: name ?? this.name,
        college: college ?? this.college,
        phone: phone ?? this.phone,
      );

  static UserModel fromJson(Map<String, Object?> json) => UserModel(
        uid: json[userFields.uid] as String?,
        email: json[userFields.email] as String?,
        name: json[userFields.name] as String?,
        college: json[userFields.college] as String,
        phone: json[userFields.phone] as String,
      );
}
