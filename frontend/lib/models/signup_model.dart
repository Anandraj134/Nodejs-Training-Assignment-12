class SignupModel {
  String username;
  String email;
  String password;
  String? bio;
  String? profilePictureUrl;
  String? contactDetails;

  SignupModel({
    required this.username,
    required this.email,
    required this.password,
    String? bio,
    String? profilePictureUrl,
    String? contactDetails,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) => SignupModel(
        username: json["username"],
        email: json["email"],
        password: json["password"],
        bio: json["bio"],
        profilePictureUrl: json["profile_picture_url"],
        contactDetails: json["contact_details"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
        "profile_picture_url": profilePictureUrl,
        "bio": bio,
        "contact_details": contactDetails,
      };
}
