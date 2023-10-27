import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/providers/blog_provider.dart';
import 'package:assignment_12/providers/comment_provider.dart';
import 'package:assignment_12/providers/portfolio_provider.dart';
import 'package:assignment_12/providers/user_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class BlogDetailsScreen extends StatelessWidget {
  const BlogDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final commentProvider = Provider.of<CommentProvider>(context);

    final index = blogProvider.currentSelectedBlog;
    final userId = blogProvider.blogs[index].userId.toString();
    return Scaffold(
      backgroundColor: WhiteColor.white,
      appBar: AppBar(
        backgroundColor: WhiteColor.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: BlackColor.matte,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            getSize(20), getSize(0), getSize(20), getSize(20)),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => FadeInAnimation(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: Duration(milliseconds: 500),
                  child: ScaleAnimation(
                    delay: Duration(milliseconds: 75),
                    scale: 1.5,
                    child: widget,
                  ),
                ),
                children: [
                  customText(
                    text: blogProvider.blogs[index].title,
                    textAlign: TextAlign.start,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: getSize(25),
                    maxLines: 3,
                  ),
                  customText(
                    text:
                        "${blogProvider.blogs[index].category} ・ Last updated: ${formatDate(blogProvider.blogs[index].updatedAt)}",
                    textAlign: TextAlign.start,
                    color: GrayColor.gray,
                    fontSize: getSize(16),
                  ),
                  SizedBox(
                    height: getVerticalSize(10),
                  ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<PortfolioProvider>(context, listen: false)
                          .getUserPortfolios(
                        context: context,
                        uid: userProvider.users[userId]!.id.toString(),
                      );
                      context.pushNamed("portfolio_details",
                          extra: userProvider.users[userId]!.id.toString());
                    },
                    child: Row(
                      children: [
                        customImageView(
                          borderRadius: 8,
                          isAssetImage:
                              userProvider.users[userId]?.profilePictureUrl ==
                                  null,
                          url: userProvider.users[userId]?.profilePictureUrl ??
                              Defaults.defaultProfileImage,
                          imgHeight: getVerticalSize(40),
                          imgWidth: getHorizontalSize(40),
                        ),
                        SizedBox(
                          width: getHorizontalSize(10),
                        ),
                        customText(
                          text: "${userProvider.users[userId]?.username}",
                          textAlign: TextAlign.start,
                          color: GrayColor.gray,
                          fontSize: getFontSize(20),
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: getVerticalSize(20),
                  ),
                  customImageView(
                    url: blogProvider.blogs[index].imageUrl,
                    imgHeight: getVerticalSize(250),
                    imgWidth: width,
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: getVerticalSize(20),
                  ),
                  SizedBox(
                    height: getVerticalSize(500),
                    child: Markdown(
                      data: blogProvider.blogs[index].content,
                      styleSheet: MarkdownStyleSheet(
                        h1: AppStyle.h1Style(),
                        h2: const TextStyle(fontSize: 20),
                        a: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          commentProvider.getComments(
            context: context,
            blogId: blogProvider.blogs[index].id.toString(),
          );
          showModalBottomSheet(
            backgroundColor: WhiteColor.white,
            elevation: 10,
            shape: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                topLeft: Radius.circular(25),
              ),
            ),
            context: context,
            builder: (context) => commentsBottomSheet(
              context: context,
              userProvider: userProvider,
              blogId: blogProvider.blogs[index].id,
            ),
          );
        },
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Icon(
          Icons.comment_rounded,
          size: getFontSize(35),
        ),
      ),
    );
  }
}

Widget commentsBottomSheet(
    {required BuildContext context,
    required UserProvider userProvider,
    required int blogId}) {
  final commentProvider = Provider.of<CommentProvider>(context);
  commentProvider.scrollDown();

  if (commentProvider.isCommentFetching) {
    return SizedBox(
      height: getVerticalSize(200),
      child: Center(
        child: customPageLoadingAnimation(
          size: getSize(50),
        ),
      ),
    );
  }
  return SingleChildScrollView(
    controller: commentProvider.controller,
    child: Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: getVerticalSize(400),
        child: Column(
          children: [
            Expanded(
              child: commentProvider.comments.isEmpty
                  ? Center(
                      child: customText(
                          text: noComments,
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: getFontSize(25),
                          maxLines: 4),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final currentUser = userProvider.users[
                            commentProvider.comments[index].userId.toString()];
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customImageView(
                                url: currentUser?.profilePictureUrl ??
                                    Defaults.defaultProfileImage,
                                imgHeight: getVerticalSize(45),
                                imgWidth: getHorizontalSize(45),
                                isAssetImage:
                                    currentUser?.profilePictureUrl == null,
                                borderRadius: 8),
                            SizedBox(
                              width: getHorizontalSize(10),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  text: currentUser!.username,
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(
                                  height: getVerticalSize(5),
                                ),
                                customText(
                                  text: commentProvider.comments[index].content,
                                  maxLinesEnabled: true,
                                  fontSize: getFontSize(15),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                      itemCount: commentProvider.comments.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(
                          color: GrayColor.gray,
                        );
                      },
                    ),
            ),
            Row(
              children: [
                Container(
                  width: getHorizontalSize(340),
                  padding:
                      EdgeInsets.only(left: getSize(20), right: getSize(20)),
                  decoration: AppDecoration.inputBoxDecorationShadow(),
                  child: TextFormField(
                    controller: commentProvider.commentController,
                    decoration: AppDecoration().textInputDecorationWhite(
                        lableText: "Comment",
                        hintText: "Add Comment Here",
                        icon: Icons.comment_outlined),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    commentProvider.addNewComment(
                      context: context,
                      content: commentProvider.commentController.text,
                      blogId: blogId,
                    );
                  },
                  child: Container(
                    height: getSize(50),
                    width: getSize(50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // shape: BoxShape.circle,
                      color: AppColor.primaryColor,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: WhiteColor.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getVerticalSize(10),
            ),
          ],
        ),
      ),
    ),
  );
}
