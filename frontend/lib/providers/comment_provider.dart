import 'dart:async';
import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/comment_model.dart';

class CommentProvider with ChangeNotifier {
  List<CommentModel> comments = <CommentModel>[];
  TextEditingController commentController = TextEditingController();
  final ScrollController controller = ScrollController();

  bool isCommentFetching = false;

  void commentToggle() {
    isCommentFetching = !isCommentFetching;
    notifyListeners();
  }

  void scrollDown() {
    Timer(const Duration(milliseconds: 50), () {
      controller.jumpTo(controller.position.maxScrollExtent);
    });
  }

  Future<void> getComments(
      {required BuildContext context, required String blogId}) async {
    comments.clear();
    commentToggle();
    try {
      Response response = await Dio().get(
        "$baseUrl/$commentApiRoutes/$blogId",
        options: Options(
          headers: {"Authorization": authToken},
        ),
      );
      if (response.data["success"]) {
        print(response.data);
        for (var i in response.data["data"]) {
          print(i);
          comments.add(CommentModel.fromJson(i as Map<String, dynamic>));
        }
        commentToggle();
      } else {
        if (!context.mounted) return;
        customToastMessage(context: context, desc: response.data["data"]);
        commentToggle();
      }
    } on DioException catch (error) {
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.response?.data["data"]);
      commentToggle();
    } catch (error) {
      print(error.toString());
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.toString());
      commentToggle();
    }
  }

  Future<void> addNewComment(
      {required BuildContext context,
      required String content,
      required int blogId}) async {
    try {
      Response response = await Dio().post(
        "$baseUrl/$commentApiRoutes",
        data: {"content": content, "blog_id": blogId},
        options: Options(
          headers: {"Authorization": authToken},
        ),
      );
      if (response.data["success"]) {
        comments.add(CommentModel.fromJson(response.data["data"]));
        commentController.clear();
        scrollDown();
        notifyListeners();
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
