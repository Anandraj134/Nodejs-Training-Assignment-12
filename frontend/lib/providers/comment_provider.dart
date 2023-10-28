import 'dart:async';
import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/comment_model.dart';

class CommentProvider with ChangeNotifier {
  List<CommentModel> comments = <CommentModel>[];
  TextEditingController commentController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool isCommentFetching = false;

  @override
  void dispose() {
    commentController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void commentToggle() {
    isCommentFetching = !isCommentFetching;
    notifyListeners();
  }

  void scrollDown() {
    Timer(const Duration(milliseconds: 50), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  Future<void> getComments(
      {required BuildContext context, required String blogId}) async {
    comments.clear();
    commentToggle();
    dioGetRequest(
      url: "$baseUrl/$commentApiRoutes/$blogId",
      successCallback: (responseData) {
        for (var i in responseData["data"]) {
          comments.add(CommentModel.fromJson(i as Map<String, dynamic>));
        }
        commentToggle();
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
        commentToggle();
      },
      contextMounted: context.mounted,
    );
  }

  Future<void> addNewComment(
      {required BuildContext context,
      required String content,
      required int blogId}) async {
    dioPostRequest(
      url: "$baseUrl/$commentApiRoutes",
      data: {"content": content, "blog_id": blogId},
      successCallback: (responseData) {
        comments.add(CommentModel.fromJson(responseData["data"]));
        commentController.clear();
        scrollDown();
        notifyListeners();
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
      },
      contextMounted: context.mounted,
    );
  }
}
