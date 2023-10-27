import 'dart:convert';

import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/core/utils/permission_manager.dart';
import 'package:assignment_12/models/blog_model.dart';
import 'package:assignment_12/providers/blog_provider.dart';

class AddBlogScreen extends StatelessWidget {
  const AddBlogScreen({super.key, required this.blog});

  final String blog;

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);
    BlogModel currentBlog = BlogModel(
      id: 0,
      title: "title",
      content: "content",
      imageUrl: "imageUrl",
      category: "category",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: 0,
    );
    if (blog.length != 21) {
      currentBlog = BlogModel.fromJson(jsonDecode(blog));
      blogProvider.titleController.text = currentBlog.title;
      blogProvider.profileURL = currentBlog.imageUrl;
      blogProvider.contentController.text = currentBlog.content;
    }

    return Scaffold(
      backgroundColor: WhiteColor.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            blogProvider.getBlogs(context: context);
            blogProvider.changeCurrentSelectedBlog(index: -1);
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: BlackColor.matte,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: WhiteColor.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: getSize(20),
          right: getSize(20),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: blogProvider.blogFormKey,
            child: Column(
              children: [
                SizedBox(
                  height: getVerticalSize(30),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      if (await storagePermissionManager()) {
                        blogProvider.openImagePicker();
                      } else {
                        if (!context.mounted) return;
                        customToastMessage(
                          context: context,
                          desc: storagePermissionError,
                        );
                      }
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _buildImagePicker(blogProvider, currentBlog),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: WhiteColor.white,
                                width: 4,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(getSize(5)),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: WhiteColor.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(50),
                ),
                Container(
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
                          blogProvider.changeDropdownItem(item!);
                        },
                        hint: const Text('Select a value'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
                Container(
                  decoration: AppDecoration.inputBoxDecorationShadow(),
                  child: TextFormField(
                    style: AppStyle.textFormFieldStyle(
                      fontSize: getFontSize(20),
                      color: BlackColor.jetBlack,
                    ),
                    controller: blogProvider.titleController,
                    decoration: AppDecoration().textInputDecorationWhite(
                      lableText: "Title",
                      icon: Icons.title,
                      hintText: "Enter Title Here",
                    ),
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
                Container(
                  decoration: AppDecoration.inputBoxDecorationShadow(),
                  child: TextFormField(
                    style: AppStyle.textFormFieldStyle(
                      fontSize: getFontSize(20),
                      color: BlackColor.jetBlack,
                    ),
                    controller: blogProvider.contentController,
                    decoration: AppDecoration().textInputDecorationWhite(
                      lableText: "Content",
                      icon: Icons.description_rounded,
                      hintText: "Enter Content Here",
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(40),
                ),
                GestureDetector(
                  onTap: () {
                    if (blogProvider.profileImage == null) {
                      customToastMessage(
                          context: context, desc: "Blog Image is Required");
                    } else if (blogProvider.blogFormKey.currentState!
                        .validate()) {
                      if (blog.length == 21) {
                        blogProvider.addNewBlog(context: context);
                      } else {
                        blogProvider.updateBlog(
                          context: context,
                          id: currentBlog.id,
                        );
                      }
                    }
                  },
                  child: Container(
                    height: getVerticalSize(50),
                    decoration: AppDecoration.buttonBoxDecoration(),
                    child: Center(
                      child: blogProvider.isAddBlogPressed
                          ? customButtonLoadingAnimation(
                              size: 50,
                            )
                          : customText(
                              text: "Submit",
                              color: WhiteColor.white,
                              fontWeight: FontWeight.w500,
                              fontSize: getFontSize(23),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildImagePicker(BlogProvider blogProvider, BlogModel currentBlog) {
  return SizedBox(
    width: width * 0.5,
    height: height * 0.25,
    child: Container(
      decoration: AppDecoration.inputBoxDecorationShadow(),
      child: Container(
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        width: height * 0.2,
        height: height * 0.25,
        decoration: BoxDecoration(
          color: WhiteColor.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: blogProvider.profileImage != null
            ? Image.file(blogProvider.profileImage!, fit: BoxFit.cover)
            : customImageView(
                url: currentBlog.imageUrl,
                imgHeight: height * 0.25,
                imgWidth: width * 0.5,
                fit: BoxFit.cover,
              ),
      ),
    ),
  );
}
