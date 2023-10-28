import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/login_model.dart';
import 'package:assignment_12/models/user_model.dart';
import 'package:assignment_12/providers/user_provider.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  bool isLoginPressed = false;
  bool obscureText = true;

  void obscureTextToggle() {
    obscureText = !obscureText;
    notifyListeners();
  }

  void loginToggle() {
    isLoginPressed = !isLoginPressed;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> onLogin({required BuildContext context}) async {
    loginToggle();
    LoginModel loginModel = LoginModel(
      email: emailController.text,
      password: passwordController.text,
    );
    dioPostRequest(
      url: "$baseUrl/$loginApiRoute",
      data: loginModel.toJson(),
      successCallback: (responseData) {
        authToken = "Bearer ${responseData["token"]}";
        writeStorage(storageAuthToken, authToken);
        Provider.of<UserProfileProvider>(context).currentUserDetails =
            UserModel.fromJson(
          responseData["data"],
        );
        writeStorage(storageUserId,
            Provider.of<UserProfileProvider>(context, listen: false).userId.toString());
        if (!context.mounted) return;
        Provider.of<UserProvider>(context, listen: false)
            .fetchUser(context: context);
        context.pushReplacementNamed("portfolio");
        emailController.clear();
        passwordController.clear();
        loginToggle();
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
        loginToggle();
      },
      contextMounted: context.mounted,
    );
  }
}
