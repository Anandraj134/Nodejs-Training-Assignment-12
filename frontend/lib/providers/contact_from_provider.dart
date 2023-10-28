import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/contact_form_model.dart';

class ContactFormProvider with ChangeNotifier {
  final GlobalKey<FormState> contactFormKey = GlobalKey<FormState>();

  bool isFormSubmitting = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  void formSubmittingToggle() {
    isFormSubmitting = !isFormSubmitting;
    notifyListeners();
  }

  Future<void> submitForm(
      {required BuildContext context,
      required String receiverEmail,
      required String receiverName}) async {
    formSubmittingToggle();
    ContactFormModel contactFormModel = ContactFormModel(
      receiverEmail: receiverEmail,
      title: titleController.text,
      description: descController.text,
      senderName:
          Provider.of<UserProfileProvider>(context, listen: false).username,
      receiverName: receiverName,
    );
    dioPostRequest(
      url: "$baseUrl/$contactFormApiRoute",
      data: contactFormModel.toJson(),
      successCallback: (responseData) {
        if (!context.mounted) return;
        customToastMessage(
          context: context,
          desc: responseData["data"],
          isSuccess: true,
        );
        titleController.clear();
        descController.clear();
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
        formSubmittingToggle();
      },
      contextMounted: context.mounted,
    );
  }
}
