
class User {
  int? id;
  String? username;
  bool? active;
  String? birthPlace;
  String? confirmPassword;
  String? displayName;
  String? dob;
  String? email;
  String? firstName;
  String? lastName;
  String? password;
  String? university;
  int? year;
  String? gender;

  User({
    this.id,
    this.username,
    this.active,
    this.birthPlace,
    this.confirmPassword,
    this.displayName,
    this.dob,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.university,
    this.year,
    this.gender
  });
  User.fromJson(Map<String, dynamic> json) {
    // List<dynamic> listRoles = json['roles']??[];
    // List<Role> rolesList = listRoles.cast<Role>().toList();
    id = json['id'];
    username = json['username'];
    active = json['active'];
    birthPlace = json['birthPlace'];
    confirmPassword = json['confirmPassword'];
    displayName = json['displayName'];
    dob = json['dob'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    password = json['password'];
    university = json['university'];
    year = json['year'];
    gender = json['gender'];
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username':username,
      'active':active,
      'birthPlace':birthPlace,
      'confirmPassword':confirmPassword,
      "displayName":displayName,
      'dob':dob,
      'email':email,
      'firstName':firstName,
      'lastName':lastName,
      'password':password,
      // 'roles': roles?.map((roles) => roles.toJson()).toList(),
      'university':university,
      'year':year,
      'gender':gender,
      // 'hasPhoto':hasPhoto
    };
  }
}
