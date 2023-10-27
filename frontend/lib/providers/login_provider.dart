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
    try {
      Response response = await Dio().get(
        "$baseUrl/$authApiRoute",
        data: loginModel.toJson(),
      );
      if (response.data["success"]) {
        authToken = "Bearer ${response.data["token"]}";
        writeStorage(storageAuthToken, authToken);
        currentUserDetails = UserModel.fromJson(
          response.data["data"],
        );
        writeStorage(storageUserId, currentUserDetails.id.toString());
        if (!context.mounted) return;
        Provider.of<UserProvider>(context, listen: false)
            .fetchUser(context: context);
        context.pushReplacementNamed("portfolio");
        emailController.clear();
        passwordController.clear();
        loginToggle();
      } else {
        if (!context.mounted) return;
        customToastMessage(context: context, desc: response.data["data"]);
      }
    } on DioException catch (error) {
      loginToggle();
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.response?.data["data"]);
    } catch (error) {
      loginToggle();
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.toString());
    }
  }
}