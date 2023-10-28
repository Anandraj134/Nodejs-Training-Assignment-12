import 'dart:io';
import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider with ChangeNotifier {
  final GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController contactDetailsController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String profileURL = "";

  final ImagePicker _picker = ImagePicker();
  File? profileImage;

  bool isUpdatingProfile = false;

  void updatingProfile() {
    isUpdatingProfile = !isUpdatingProfile;
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    contactDetailsController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      notifyListeners();
    }
  }

  Future<String> uploadImage({required BuildContext context}) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final File? image = profileImage;

      final String imagePath =
          '$collectionUsers/${Provider.of<UserProfileProvider>(context, listen: false).userId}/profileImage.jpg';

      UploadTask uploadTask = storage.ref().child(imagePath).putFile(image!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      final String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      if (!context.mounted) return "";
      customToastMessage(context: context, desc: error.toString());
      return "";
    }
  }

  Future<void> updateUserProfile(
      {required BuildContext context,
      required UpdateUserModel updateUserModel}) async {
    updatingProfile();
    if (profileImage != null) {
      profileURL = await uploadImage(context: context);
      updateUserModel.profilePictureUrl = profileURL;
    }
    dioPutRequest(
      url: "$baseUrl/$userApiRoute",
      data: updateUserModel.toJson(),
      successCallback: (responseData) {
        updateProfileData(updateUserModel: updateUserModel, context: context);
        if (!context.mounted) return;
        context.pop();
        customToastMessage(
          context: context,
          desc: "Profile Updated Successfully",
          isSuccess: true,
        );
        updatingProfile();
        onClose();
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
        updatingProfile();
      },
      contextMounted: context.mounted,
    );
  }

  void onClose() {
    profileURL = "";
    profileImage = null;
  }

  void onEdit({required BuildContext context}) {
    contactDetailsController
      ..text = Provider.of<UserProfileProvider>(context, listen: false)
              .contactDetails ??
          "";
    bioController
      ..text =
          Provider.of<UserProfileProvider>(context, listen: false).bio ?? "";
    emailController
      ..text = Provider.of<UserProfileProvider>(context, listen: false).email;
    usernameController
      ..text =
          Provider.of<UserProfileProvider>(context, listen: false).username;
  }

  void updateProfileData(
      {required UpdateUserModel updateUserModel,
      required BuildContext context}) {
    Provider.of<UserProfileProvider>(context, listen: false)
        .updateUserProfile(updateUserModel);
    notifyListeners();
  }
}
