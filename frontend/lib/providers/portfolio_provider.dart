import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/portfolio_model.dart';

class PortfolioProvider with ChangeNotifier {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController technologyController = TextEditingController();
  TextEditingController githubController = TextEditingController();

  final GlobalKey<FormState> projectFormKey = GlobalKey<FormState>();

  List<PortfolioModel> portfolios = <PortfolioModel>[];

  bool isPortfolioFetching = false;
  bool isPortfolioUpdating = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    technologyController.dispose();
    githubController.dispose();
    super.dispose();
  }

  void portfolioToggle() {
    isPortfolioFetching = !isPortfolioFetching;
    notifyListeners();
  }

  void updatingPortfolio() {
    isPortfolioUpdating = !isPortfolioUpdating;
    notifyListeners();
  }

  Future<void> getUserPortfolios(
      {required BuildContext context, required String uid}) async {
    portfolios.clear();
    notifyListeners();
    portfolioToggle();

    dioGetRequest(
      url: "$baseUrl/$portfolioApiRoute/$uid",
      successCallback: (responseData) {
        for (var i in responseData["data"]) {
          portfolios.add(PortfolioModel.fromJson(i));
        }
        notifyListeners();
        portfolioToggle();
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
        portfolioToggle();
      },
      contextMounted: context.mounted,
    );
  }

  Future<void> deletePortfolio(
      {required BuildContext context, required String id}) async {
    dioDeleteRequest(
      url: "$baseUrl/$portfolioApiRoute/$id",
      successCallback: (responseData) {
        getUserPortfolios(
          context: context,
          uid: Provider.of<UserProfileProvider>(context, listen: false)
              .userId
              .toString(),
        );
        customToastMessage(
          context: context,
          desc: "Portfolio Deleted Successfully",
          isSuccess: true,
        );
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
      },
      contextMounted: context.mounted,
    );
  }

  Future<void> addProject({
    required BuildContext context,
  }) async {
    updatingPortfolio();
    EditPortfolioModel editPortfolioModel = EditPortfolioModel(
      title: titleController.text,
      description: descriptionController.text,
      technologiesUsed: technologyController.text,
      githubLink: githubController.text,
    );
    dioPostRequest(
      url: "$baseUrl/$portfolioApiRoute",
      data: editPortfolioModel.toJson(),
      successCallback: (responseData) {
        if (!context.mounted) return;
        getUserPortfolios(
          context: context,
          uid: Provider.of<UserProfileProvider>(context, listen: false)
              .userId
              .toString(),
        );
        customToastMessage(
          context: context,
          desc: portfolioAdded,
          isSuccess: true,
        );
      },
      errorCallback: (errorDesc) {
        customToastMessage(context: context, desc: errorDesc);
        updatingPortfolio();
      },
      contextMounted: context.mounted,
    );
  }

  Future<void> editProject({
    required BuildContext context,
    String id = "",
  }) async {
    updatingPortfolio();
    EditPortfolioModel editPortfolioModel = EditPortfolioModel(
      title: titleController.text,
      description: descriptionController.text,
      technologiesUsed: technologyController.text,
      githubLink: githubController.text,
    );

    dioPutRequest(
      url: "$baseUrl/$portfolioApiRoute/$id",
      data: editPortfolioModel.toJson(),
      successCallback: (responseData) {
        getUserPortfolios(
          context: context,
          uid: Provider.of<UserProfileProvider>(context, listen: false)
              .userId
              .toString(),
        );
        customToastMessage(
          context: context,
          desc: portfolioUpdated,
          isSuccess: true,
        );
        updatingPortfolio();
      },
      errorCallback: (errorDesc) {
        updatingPortfolio();
        customToastMessage(context: context, desc: errorDesc);
      },
      contextMounted: context.mounted,
    );
  }

  void onSubmit() {
    titleController.clear();
    descriptionController.clear();
    githubController.clear();
    technologyController.clear();
  }

  void onEdit({
    required String title,
    required String desc,
    required String tech,
    required String githubLink,
  }) {
    titleController.text = title;
    descriptionController.text = desc;
    technologyController.text = tech;
    githubController.text = githubLink;
  }
}
