import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/signup_model.dart';
import 'package:assignment_12/models/user_model.dart';
import 'package:assignment_12/providers/user_provider.dart';

class SignupProvider with ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  bool isSignupPressed = false;
  bool obscureText = true;

  void obscureTextToggle() {
    obscureText = !obscureText;
    notifyListeners();
  }

  void signupToggle() {
    isSignupPressed = !isSignupPressed;
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSignup({required BuildContext context}) async {
    signupToggle();
    SignupModel signupModel = SignupModel(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
    );
    dioPostRequest(
      url: "$baseUrl/$signupApiRoute",
      data: signupModel.toJson(),
      successCallback: (responseData) {
        authToken = "Bearer ${responseData["token"]}";
        writeStorage(storageAuthToken, authToken);
        Provider.of<UserProfileProvider>(context).currentUserDetails =
            UserModel.fromJson(responseData["data"]);
        writeStorage(storageUserId,
            Provider.of<UserProfileProvider>(context, listen: false).userId.toString());
        Provider.of<UserProvider>(context, listen: false)
            .fetchUser(context: context);
        context.pushReplacementNamed("portfolio");
        signupToggle();
        emailController.clear();
        passwordController.clear();
        usernameController.clear();
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
        signupToggle();
      },
      contextMounted: context.mounted,
    );
  }
}
