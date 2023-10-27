import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/core/utils/permission_manager.dart';
import 'package:assignment_12/models/user_model.dart';
import 'package:assignment_12/providers/profile_provider.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: WhiteColor.white,
      appBar: AppBar(
        backgroundColor: WhiteColor.white,
        elevation: 0,
        centerTitle: true,
        title: customText(
          text: "Edit Profile",
          fontSize: getFontSize(25),
        ),
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: BlackColor.charcoalBlack,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(getSize(20)),
          child: Form(
            key: profileProvider.editProfileFormKey,
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      if (await storagePermissionManager()) {
                        profileProvider.openImagePicker();
                      } else {
                        if (!context.mounted) return;
                        customToastMessage(
                          context: context,
                          desc: storagePermissionError,
                        );
                      }
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _buildImagePicker(profileProvider),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: WhiteColor.white,
                                width: 4,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(getSize(5)),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: WhiteColor.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(50),
                ),
                Container(
                  decoration: AppDecoration.inputBoxDecorationShadow(),
                  child: TextFormField(
                    style: AppStyle.textFormFieldStyle(),
                    controller: profileProvider.usernameController
                      ..text = currentUserDetails.username,
                    decoration: AppDecoration().textInputDecorationWhite(
                      icon: Icons.person_outlined,
                      hintText: "Username",
                      lableText: "Username",
                    ),
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
                Container(
                  decoration: AppDecoration.inputBoxDecorationShadow(),
                  child: TextFormField(
                    style: AppStyle.textFormFieldStyle(),
                    controller: profileProvider.emailController
                      ..text = currentUserDetails.email,
                    decoration: AppDecoration().textInputDecorationWhite(
                      icon: Icons.email_outlined,
                      hintText: "Email",
                      lableText: "Email",
                    ),
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
                Container(
                  decoration: AppDecoration.inputBoxDecorationShadow(),
                  child: TextFormField(
                    style: AppStyle.textFormFieldStyle(),
                    controller: profileProvider.bioController
                      ..text = currentUserDetails.bio ?? "",
                    decoration: AppDecoration().textInputDecorationWhite(
                      icon: Icons.description_outlined,
                      hintText: "Bio",
                      lableText: "Bio",
                    ),
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
                Container(
                  decoration: AppDecoration.inputBoxDecorationShadow(),
                  child: TextFormField(
                    style: AppStyle.textFormFieldStyle(),
                    controller: profileProvider.contactDetailsController
                      ..text = currentUserDetails.contactDetails ?? "",
                    decoration: AppDecoration().textInputDecorationWhite(
                      icon: Icons.contact_emergency_outlined,
                      hintText: "Contact",
                      lableText: "Contact",
                    ),
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(40),
                ),
                GestureDetector(
                  onTap: () {
                    if (profileProvider.editProfileFormKey.currentState!
                        .validate()) {
                      UpdateUserModel updateUserModel = UpdateUserModel(
                        username: profileProvider.usernameController.text,
                        email: profileProvider.emailController.text,
                        profilePictureUrl: profileProvider.profileURL,
                        bio: profileProvider.bioController.text,
                        contactDetails:
                            profileProvider.contactDetailsController.text,
                      );
                      profileProvider.updateUserProfile(
                        context: context,
                        updateUserModel: updateUserModel,
                      );
                    }
                  },
                  child: Container(
                    height: getVerticalSize(50),
                    decoration: AppDecoration.buttonBoxDecoration(),
                    child: Center(
                      child: profileProvider.isUpdatingProfile
                          ? customButtonLoadingAnimation(
                              size: 50,
                            )
                          : customText(
                              text: "Update",
                              color: WhiteColor.white,
                              fontWeight: FontWeight.w500,
                              fontSize: getFontSize(23),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildImagePicker(ProfileProvider profileProvider) {
  return SizedBox(
    width: width * 0.5,
    height: height * 0.25,
    child: Container(
      decoration: AppDecoration.inputBoxDecorationShadow(),
      child: Container(
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        width: height * 0.2,
        height: height * 0.25,
        decoration: BoxDecoration(
          color: WhiteColor.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: profileProvider.profileImage != null
            ? Image.file(profileProvider.profileImage!, fit: BoxFit.cover)
            : customImageView(
                url: currentUserDetails.profilePictureUrl ??
                    Defaults.defaultProfileImage,
                imgHeight: height * 0.25,
                imgWidth: width * 0.5,
                fit: BoxFit.cover,
                isAssetImage: currentUserDetails.profilePictureUrl == null,
              ),
      ),
    ),
  );
}
