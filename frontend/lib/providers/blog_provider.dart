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
          '$collectionBlogs/${Provider.of<UserProfileProvider>(context, listen: false).userId}/blogImage.jpg';

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

  Future<void> getBlogs(
      {required BuildContext context, String category = ""}) async {
    initBlogToggle();
    blogs.clear();

    dioGetRequest(
      url: "$baseUrl/$blogApiRoute/$category",
      successCallback: (responseData) {
        for (var i in responseData["data"]) {
          blogs.add(BlogModel.fromJson(i));
        }
        initBlogToggle();
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
        initBlogToggle();
      },
      contextMounted: context.mounted,
    );
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
    dioPostRequest(
      url: "$baseUrl/$blogApiRoute",
      data: addBlogModel.toJson(),
      successCallback: (responseData) {
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
        addBlogToggle();
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
        addBlogToggle();
      },
      contextMounted: context.mounted,
    );
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

    dioPutRequest(
      url: "$baseUrl/$blogApiRoute/${id.toString()}",
      data: addBlogModel.toJson(),
      successCallback: (responseData) {
        customToastMessage(
          context: context,
          desc: "Blog Updated Successfully",
          isSuccess: true,
        );
        clearAddBlog();
        changeCurrentSelectedBlog(index: -1);
        Provider.of<BlogProvider>(context, listen: false)
            .getBlogs(context: context);
        addBlogToggle();
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
        addBlogToggle();
      },
      contextMounted: context.mounted,
    );
  }

  Future<void> deleteBlog(
      {required BuildContext context, required int index}) async {
    dioDeleteRequest(
      url: "$baseUrl/$blogApiRoute/${blogs[index].id}",
      successCallback: (responseData) {
        if (!context.mounted) return;
        customToastMessage(
          context: context,
          desc: responseData["data"],
          isSuccess: true,
        );
        blogs.removeAt(index);
        notifyListeners();
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
      },
      contextMounted: context.mounted,
    );
  }

  void clearAddBlog() {
    titleController.clear();
    contentController.clear();
    profileURL = "";
    profileImage = null;
    selectedCategory = blogCategory[0];
  }
}
