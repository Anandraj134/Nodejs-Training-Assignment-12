import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/user_model.dart';

class UserProfileProvider with ChangeNotifier {
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

  void updateUserProfile(UpdateUserModel newUserDetails) {
    currentUserDetails.username = newUserDetails.username;
    currentUserDetails.email = newUserDetails.email;
    currentUserDetails.profilePictureUrl = newUserDetails.profilePictureUrl;
    currentUserDetails.bio = newUserDetails.bio;
    currentUserDetails.contactDetails = newUserDetails.contactDetails;
    notifyListeners();
  }

  void setUserId(int newUserId) {
    currentUserDetails.id = newUserId;
    notifyListeners();
  }

  int get userId => currentUserDetails.id;

  String get username => currentUserDetails.username;

  String get email => currentUserDetails.email;

  String? get bio => currentUserDetails.bio;

  String? get profilePictureUrl => currentUserDetails.profilePictureUrl;

  String? get contactDetails => currentUserDetails.contactDetails;
}
