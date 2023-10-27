import 'package:assignment_12/models/user_model.dart';

String authToken = "";

int selectedBottomNavigationIndex = 0;

UserModel currentUserDetails = UserModel(
  id: -1,
  username: "",
  email: "",
  password: "",
  bio: null,
  profilePictureUrl: null,
  contactDetails: null,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
