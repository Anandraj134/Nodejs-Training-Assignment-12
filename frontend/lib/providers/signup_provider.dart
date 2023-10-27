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
    try {
      Response response = await Dio().post(
        "$baseUrl/$authApiRoute",
        data: signupModel.toJson(),
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
        signupToggle();
        emailController.clear();
        passwordController.clear();
        usernameController.clear();
      } else {
        if (!context.mounted) return;
        customToastMessage(context: context, desc: response.data["data"]);
      }
    } on DioException catch (error) {
      signupToggle();
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.response?.data["data"]);
    } catch (error) {
      signupToggle();
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.toString());
    }
  }
}
