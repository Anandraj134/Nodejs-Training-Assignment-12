import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/user_model.dart';

class UserProvider with ChangeNotifier {
  Map<String, UserModel> users = <String, UserModel>{};

  Future<void> fetchUser({required BuildContext context}) async {
    dioGetRequest(
      url: "$baseUrl/$userApiRoute",
      successCallback: (responseData) {
        for (var i in responseData["data"]) {
          users[i["id"].toString()] =
              UserModel.fromJson(i as Map<String, dynamic>);
        }
        notifyListeners();
        Provider.of<UserProfileProvider>(context, listen: false)
                .currentUserDetails =
            users[Provider.of<UserProfileProvider>(context, listen: false)
                .userId
                .toString()]!;
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
      },
      contextMounted: context.mounted,
    );
  }
}
