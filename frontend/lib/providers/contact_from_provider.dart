import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/contact_form_model.dart';
import 'package:assignment_12/providers/user_provider.dart';

class ContactFormProvider with ChangeNotifier {
  final GlobalKey<FormState> contactFormKey = GlobalKey<FormState>();

  bool isFormSubmitting = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  void formSubmittingToggle() {
    isFormSubmitting = !isFormSubmitting;
    notifyListeners();
  }

  Future<void> submitForm(
      {required BuildContext context, required String receiverEmail, required String receiverName}) async {
    formSubmittingToggle();
    ContactFormModel contactFormModel = ContactFormModel(
      receiverEmail: receiverEmail,
      title: titleController.text,
      description: descController.text,
      senderName: currentUserDetails.username,
      receiverName: receiverName,
    );
    try {
      Response response = await Dio().post(
        "$baseUrl/$contactFormApiRoute",
        data: contactFormModel.toJson(),
        options: Options(
          headers: {"Authorization": authToken},
        ),
      );
      if (response.data["success"]) {
        if (!context.mounted) return;
        customToastMessage(
          context: context,
          desc: response.data["data"],
          isSuccess: true,
        );
        titleController.clear();
        descController.clear();
      } else {
        if (!context.mounted) return;
        customToastMessage(context: context, desc: response.data["data"]);
      }
      formSubmittingToggle();
    } on DioException catch (error) {
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.response?.data["data"]);
      formSubmittingToggle();
    } catch (error) {
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.toString());
      formSubmittingToggle();
    }
  }
}
