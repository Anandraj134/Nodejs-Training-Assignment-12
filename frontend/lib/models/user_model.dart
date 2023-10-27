class UserModel {
  int id;
  String username;
  String email;
  String password;
  String? bio;
  String? profilePictureUrl;
  String? contactDetails;
  DateTime createdAt;
  DateTime updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.bio,
    this.profilePictureUrl,
    this.contactDetails,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        bio: json["bio"],
        profilePictureUrl: json["profile_picture_url"],
        contactDetails: json["contact_details"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "bio": bio,
        "profile_picture_url": profilePictureUrl,
        "contact_details": contactDetails,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class UpdateUserModel {
  String username;
  String email;
  String? bio;
  String? profilePictureUrl;
  String? contactDetails;

  UpdateUserModel({
    required this.username,
    required this.email,
    this.bio,
    this.profilePictureUrl,
    this.contactDetails,
  });

  factory UpdateUserModel.fromJson(Map<String, dynamic> json) =>
      UpdateUserModel(
        username: json["username"],
        email: json["email"],
        bio: json["bio"],
        profilePictureUrl: json["profile_picture_url"],
        contactDetails: json["contact_details"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "bio": bio,
        "profile_picture_url": profilePictureUrl,
        "contact_details": contactDetails,
      };
}
