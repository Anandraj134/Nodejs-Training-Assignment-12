import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/user_model.dart';

class UserProvider with ChangeNotifier {
  Map<String, UserModel> users = <String, UserModel>{};

  Future<void> fetchUser({required BuildContext context}) async {
    try {
      Response response = await Dio().get(
        "$baseUrl/$userApiRoute",
        options: Options(
          headers: {"Authorization": authToken},
        ),
      );
      if (response.data["success"]) {
        for (var i in response.data["data"]) {
          users[i["id"].toString()] =
              UserModel.fromJson(i as Map<String, dynamic>);
        }
        notifyListeners();
        currentUserDetails = users[currentUserDetails.id.toString()]!;
      } else {
        if (!context.mounted) return;
        customToastMessage(context: context, desc: response.data["data"]);
      }
    } on DioException catch (error) {
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.response?.data["data"]);
    } catch (error) {
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.toString());
    }
  }
}
