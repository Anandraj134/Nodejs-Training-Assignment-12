import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/blog_model.dart';
import 'package:image_picker/image_picker.dart';

class BlogProvider with ChangeNotifier {
  final GlobalKey<FormState> blogFormKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  List<BlogModel> blogs = <BlogModel>[];
  String profileURL = "";
  bool isAddBlogPressed = false;
  bool initBlogLoad = false;
  String selectedCategory = blogCategory[0];
  int currentSelectedBlog = -1;

  final ImagePicker _picker = ImagePicker();
  File? profileImage;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
    profileImage = null;
  }

  void changeCurrentSelectedBlog({required int index}) {
    currentSelectedBlog = index;
    notifyListeners();
  }

  void changeDropdownItem(String item) {
    selectedCategory = item;
    notifyListeners();
  }

  void addBlogToggle() {
    isAddBlogPressed = !isAddBlogPressed;
    notifyListeners();
  }

  void initBlogToggle() {
    initBlogLoad = !initBlogLoad;
    notifyListeners();
  }

  Future<void> openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      notifyListeners();
    }
  }

  Future<String> uploadImage({required BuildContext context}) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final File? image = profileImage;

      final String imagePath =
          '$collectionBlogs/${currentUserDetails.id}/blogImage.jpg';

      UploadTask uploadTask = storage.ref().child(imagePath).putFile(image!);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      final String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      if (!context.mounted) return "";
      customToastMessage(context: context, desc: error.toString());
      return "";
    }
  }

  Future<void> getBlogs({required BuildContext context, String category = ""}) async {
    initBlogToggle();
    blogs.clear();
    try {
      Response response = await Dio().get(
        "$baseUrl/$blogApiRoute/$category",
        options: Options(
          headers: {"Authorization": authToken},
        ),
      );
      if (response.data["success"]) {
        for (var i in response.data["data"]) {
          blogs.add(BlogModel.fromJson(i));
        }
        initBlogToggle();
      } else {
        if (!context.mounted) return;
        customToastMessage(context: context, desc: response.data["data"]);
      }
    } on DioException catch (error) {
      initBlogToggle();
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.response?.data["data"]);
    } catch (error) {
      initBlogToggle();
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.toString());
    }
  }

  Future<void> addNewBlog({required BuildContext context}) async {
    addBlogToggle();
    if (profileImage != null) {
      profileURL = await uploadImage(context: context);
    }
    AddBlogModel addBlogModel = AddBlogModel(
      title: titleController.text,
      content: contentController.text,
      imageUrl: profileURL,
      category: selectedCategory,
    );
    try {
      Response response = await Dio().post(
        "$baseUrl/$blogApiRoute",
        data: addBlogModel.toJson(),
        options: Options(
          headers: {"Authorization": authToken},
        ),
      );
      if (response.data["success"]) {
        if (!context.mounted) return;
        customToastMessage(
          context: context,
          desc: "Blog Added Successfully",
          isSuccess: true,
        );
        clearAddBlog();
        changeCurrentSelectedBlog(index: -1);
        Provider.of<BlogProvider>(context, listen: false)
            .getBlogs(context: context);
      } else {
        if (!context.mounted) return;
        customToastMessage(context: context, desc: response.data["data"]);
      }
      addBlogToggle();
    } on DioException catch (error) {
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.response?.data["data"]);
      addBlogToggle();
    } catch (error) {
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.toString());
      addBlogToggle();
    }
  }

  Future<void> updateBlog({
    required BuildContext context,
    required int id,
  }) async {
    addBlogToggle();
    if (profileImage != null) {
      profileURL = await uploadImage(context: context);
    }
    AddBlogModel addBlogModel = AddBlogModel(
      title: titleController.text,
      content: contentController.text,
      imageUrl: profileURL,
      category: selectedCategory,
    );
    try {
      Response response = await Dio().put(
        "$baseUrl/$blogApiRoute/${id.toString()}",
        data: addBlogModel.toJson(),
        options: Options(
          headers: {"Authorization": authToken},
        ),
      );
      if (response.data["success"]) {
        if (!context.mounted) return;
        customToastMessage(
          context: context,
          desc: "Blog Updated Successfully",
          isSuccess: true,
        );
        clearAddBlog();
        changeCurrentSelectedBlog(index: -1);
        Provider.of<BlogProvider>(context, listen: false)
            .getBlogs(context: context);
      } else {
        if (!context.mounted) return;
        customToastMessage(context: context, desc: response.data["data"]);
      }
      addBlogToggle();
    } on DioException catch (error) {
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.response?.data["data"]);
      addBlogToggle();
    } catch (error) {
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.toString());
      addBlogToggle();
    }
  }

  Future<void> deleteBlog(
      {required BuildContext context, required int index}) async {
    try {
      Response response = await Dio().delete(
        "$baseUrl/$blogApiRoute/${blogs[index].id}",
        options: Options(
          headers: {"Authorization": authToken},
        ),
      );
      if (response.data["success"]) {
        if (!context.mounted) return;
        customToastMessage(
          context: context,
          desc: response.data["data"],
          isSuccess: true,
        );
        blogs.removeAt(index);
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

  void clearAddBlog() {
    titleController.clear();
    contentController.clear();
    profileURL = "";
    profileImage = null;
    selectedCategory = blogCategory[0];
  }
}
