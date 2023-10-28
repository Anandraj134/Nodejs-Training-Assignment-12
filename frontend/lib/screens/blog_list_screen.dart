import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/providers/blog_provider.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);
    final currentUserProvider = Provider.of<UserProfileProvider>(context);
    return Scaffold(
      backgroundColor: WhiteColor.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: "Filter",
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    width: width * 0.9,
                    height: height * 0.071,
                    decoration: AppDecoration.containerBoxDecoration(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: width * 0.05,
                        right: width * 0.05,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          style: AppStyle.textFormFieldStyle(
                            color: BlackColor.matte,
                            fontSize: getFontSize(18),
                          ),
                          borderRadius: BorderRadius.circular(12),
                          dropdownColor: Colors.white,
                          focusColor: Colors.white,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 30,
                          ),
                          value: blogProvider.selectedCategory,
                          items: blogCategory
                              .map((String key) => DropdownMenuItem<String>(
                                    value: key,
                                    child: Text(key),
                                  ))
                              .toList(),
                          onChanged: (String? item) {
                            context.pop();

                            if (item != blogCategory[0]) {
                              blogProvider.getBlogs(
                                  context: context, category: item!);
                            } else {
                              blogProvider.getBlogs(context: context);
                            }
                          },
                          hint: const Text('Select a value'),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(
              Icons.filter_alt,
              color: AppColor.primaryColor,
              size: getSize(30),
            ),
          )
        ],
        title: Row(
          children: [
            customImageView(
              borderRadius: 0,
              isAssetImage: true,
              url: AppImages.blogfolioIcon,
              imgHeight: getSize(40),
              imgWidth: getSize(40),
            ),
            SizedBox(
              width: getHorizontalSize(10),
            ),
            customTitleText(
              text: "Blog",
              fontSize: getFontSize(30),
              color: AppColor.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        backgroundColor: WhiteColor.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        backgroundColor: AppColor.primaryColor,
        color: WhiteColor.white,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          blogProvider.getBlogs(context: context);
        },
        child: Consumer<BlogProvider>(
          builder: (context, blogProvider, child) {
            if (blogProvider.initBlogLoad) {
              return Center(
                child: customPageLoadingAnimation(
                  size: getSize(50),
                ),
              );
            } else if (blogProvider.blogs.isEmpty) {
              return Center(
                child: customText(
                  text: "No Blogs Found",
                  color: AppColor.primaryColor,
                  fontSize: getFontSize(25),
                  fontWeight: FontWeight.bold,
                  maxLines: 3,
                ),
              );
            } else {
              return AnimationLimiter(
                child: ListView.separated(
                  padding: EdgeInsets.all(
                    getSize(20),
                  ),
                  itemBuilder: (context, index) {
                    final currentBlog = blogProvider.blogs[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: FadeInAnimation(
                        delay: const Duration(milliseconds: 100),
                        child: SlideAnimation(
                          horizontalOffset: -50.0,
                          delay: const Duration(milliseconds: 60),
                          child: GestureDetector(
                            onTap: () {
                              blogProvider.changeCurrentSelectedBlog(
                                  index: index);
                              context.pushNamed("blog_details");
                            },
                            child: Container(
                              decoration: AppDecoration.containerBoxDecoration(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: "BlogImage_${currentBlog.id}",
                                    child: customImageView(
                                      url: currentBlog.imageUrl,
                                      imgHeight: getVerticalSize(110),
                                      imgWidth: getHorizontalSize(100),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getHorizontalSize(10),
                                  ),
                                  SizedBox(
                                    height: getVerticalSize(110),
                                    width: width - getHorizontalSize(150),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customText(
                                          fontSize: getFontSize(23),
                                          text: currentBlog.title,
                                          color: AppColor.primaryColor,
                                          textAlign: TextAlign.start,
                                          fontWeight: FontWeight.bold,
                                          maxLines: 2,
                                        ),
                                        SizedBox(
                                          height: getVerticalSize(5),
                                        ),
                                        customText(
                                          text: currentBlog.category,
                                          color: GrayColor.gray,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            customText(
                                              text: formatDate(
                                                  currentBlog.updatedAt),
                                              color: GrayColor.gray,
                                            ),
                                            if (currentUserProvider.userId ==
                                                currentBlog.userId)
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      context.pushNamed(
                                                          "add_blog",
                                                          extra: currentBlog
                                                              .toJson());
                                                    },
                                                    child: const Icon(
                                                      Icons.edit,
                                                      color: BlackColor.matte,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getHorizontalSize(5),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      blogProvider.deleteBlog(
                                                          context: context,
                                                          index: index);
                                                    },
                                                    child: const Icon(
                                                      Icons.delete_rounded,
                                                      color: RedColor.cardinalRed,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getHorizontalSize(10),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: getVerticalSize(15),
                  ),
                  itemCount: blogProvider.blogs.length,
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          context.pushNamed("add_blog", extra: {"success": "Nothing"});
        },
        elevation: 10,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        child: Icon(
          Icons.add_rounded,
          size: getFontSize(35),
        ),
      ),
    );
  }
}
