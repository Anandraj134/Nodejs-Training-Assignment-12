import 'dart:convert';

import 'package:assignment_12/models/user_model.dart';
import 'package:assignment_12/providers/contact_from_provider.dart';
import 'package:assignment_12/core/app_export.dart';

class ContactFormScreen extends StatelessWidget {
  const ContactFormScreen({super.key, required this.receiver});

  final String receiver;

  @override
  Widget build(BuildContext context) {
    final currentUser = (UserModel.fromJson(jsonDecode(receiver)));
    final contactFormProvider = Provider.of<ContactFormProvider>(context);
    return Scaffold(
      backgroundColor: WhiteColor.white,
      appBar: AppBar(
        backgroundColor: WhiteColor.white,
        elevation: 0,
        centerTitle: true,
        title: customTitleText(
          text: "Contact Form",
          color: AppColor.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: getFontSize(30),
        ),
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back_rounded,
            color: BlackColor.matte,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Form(
            key: contactFormProvider.contactFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customImageView(
                  url: AppImages.contactUsIcon,
                  imgHeight: height * 0.2,
                  imgWidth: height * 0.2,
                  fit: BoxFit.scaleDown,
                ),
                SizedBox(
                  height: getVerticalSize(50),
                ),
                Container(
                  decoration: AppDecoration.containerBoxDecoration(),
                  child: TextFormField(
                    controller: contactFormProvider.titleController,
                    maxLines: null,
                    decoration: AppDecoration().textInputDecorationWhite(
                      hintText: "Add Title Here",
                      icon: Icons.title,
                      lableText: "Title",
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Title is required.";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
                Container(
                  decoration: AppDecoration.containerBoxDecoration(),
                  child: TextFormField(
                    controller: contactFormProvider.descController,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Description is required.";
                      }
                      return null;
                    },
                    decoration: AppDecoration().textInputDecorationWhite(
                      hintText: "Add Description Here",
                      icon: Icons.description_outlined,
                      lableText: "Description",
                    ),
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(30),
                ),
                GestureDetector(
                  onTap: () {
                    if (contactFormProvider.contactFormKey.currentState!
                        .validate()) {
                      contactFormProvider.submitForm(
                        context: context,
                        receiverEmail: currentUser.email,
                        receiverName: currentUser.username,
                      );
                    }
                  },
                  child: Container(
                    height: getVerticalSize(50),
                    decoration: AppDecoration.buttonBoxDecoration(),
                    child: Center(
                      child: contactFormProvider.isFormSubmitting
                          ? customButtonLoadingAnimation(
                              size: 50,
                            )
                          : customText(
                              text: "Send Email",
                              color: Colors.white,
                              fontSize: width * 0.06,
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
