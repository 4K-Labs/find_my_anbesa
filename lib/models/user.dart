class User {
  int? activityPoints;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? profilePicPath;
  int? userId;

  User(
      {this.activityPoints,
        this.email,
        this.firstName,
        this.lastName,
        this.phone,
        this.profilePicPath,
        this.userId});

  User.fromJson(Map<String, dynamic> json) {
    activityPoints = json['activity_points'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    profilePicPath = json['profile_pic_path'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['activity_points'] = activityPoints;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['profile_pic_path'] = profilePicPath;
    data['user_id'] = userId;
    return data;
  }
}