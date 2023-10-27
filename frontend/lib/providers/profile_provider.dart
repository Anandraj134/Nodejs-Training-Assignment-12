import 'dart:io';
import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/user_model.dart';
import 'package:assignment_12/providers/user_provider.dart';
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
          '$collectionUsers/${currentUserDetails.id}/profileImage.jpg';

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
    }
    updateUserModel.profilePictureUrl = profileURL;
    try {
      Response response = await Dio().put(
        "$baseUrl/$userApiRoute",
        data: updateUserModel.toJson(),
        options: Options(
          headers: {"Authorization": authToken},
        ),
      );
      if (response.data["success"]) {
        if (!context.mounted) return;
        Provider.of<UserProvider>(context, listen: false)
            .fetchUser(context: context);
        customToastMessage(
          context: context,
          desc: "Profile Updated Successfully",
          isSuccess: true,
        );
        context.goNamed("portfolio");
        updatingProfile();
        onClose();
      } else {
        if (!context.mounted) return;
        customToastMessage(context: context, desc: response.data["data"]);
        updatingProfile();
      }
    } on DioException catch (error) {
      updatingProfile();
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.response?.data["data"]);
    } catch (error) {
      updatingProfile();
      print(error.toString());
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.toString());
    }
  }

  void onClose() {
    profileURL = "";
    profileImage = null;
  }
}
