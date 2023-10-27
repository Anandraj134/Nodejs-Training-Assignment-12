import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/models/portfolio_model.dart';

class PortfolioProvider with ChangeNotifier {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController technologyController = TextEditingController();
  TextEditingController githubController = TextEditingController();

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
    try {
      Response response = await Dio().get(
        "$baseUrl/$portfolioApiRoute/$uid",
        options: Options(
          headers: {"Authorization": authToken},
        ),
      );
      if (response.data["success"]) {
        for (var i in response.data["data"]) {
          portfolios.add(PortfolioModel.fromJson(i));
        }
        notifyListeners();
        portfolioToggle();
      } else {
        if (!context.mounted) return;
        customToastMessage(context: context, desc: response.data["data"]);
      }
    } on DioException catch (error) {
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.response?.data["data"]);
      portfolioToggle();
    } catch (error) {
      portfolioToggle();
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.toString());
    }
  }

  Future<void> deletePortfolio(
      {required BuildContext context, required String id}) async {
    try {
      Response response = await Dio().delete(
        "$baseUrl/$portfolioApiRoute/$id",
        options: Options(
          headers: {"Authorization": authToken},
        ),
      );
      if (response.data["success"]) {
        if (!context.mounted) return;
        getUserPortfolios(
          context: context,
          uid: currentUserDetails.id.toString(),
        );
        customToastMessage(
          context: context,
          desc: "Portfolio Deleted Successfully",
          isSuccess: true,
        );
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

  Future<void> editPortfolio({
    required BuildContext context,
    required bool isEdit,
    String id = "",
  }) async {
    updatingPortfolio();
    EditPortfolioModel editPortfolioModel = EditPortfolioModel(
      title: titleController.text,
      description: descriptionController.text,
      technologiesUsed: technologyController.text,
      githubLink: githubController.text,
    );
    try {
      late Response response;
      if (isEdit) {
        response = await Dio().put(
          "$baseUrl/$portfolioApiRoute/$id",
          data: editPortfolioModel.toJson(),
          options: Options(
            headers: {"Authorization": authToken},
          ),
        );
      } else {
        response = await Dio().post(
          "$baseUrl/$portfolioApiRoute",
          data: editPortfolioModel.toJson(),
          options: Options(
            headers: {"Authorization": authToken},
          ),
        );
      }
      if (response.data["success"]) {
        context.pop();
        getUserPortfolios(
          context: context,
          uid: currentUserDetails.id.toString(),
        );
        if (isEdit) {
          if (!context.mounted) return;
          customToastMessage(
              context: context, desc: portfolioUpdated, isSuccess: true);
        } else {
          if (!context.mounted) return;
          customToastMessage(
              context: context, desc: portfolioAdded, isSuccess: true);
        }
      } else {
        if (!context.mounted) return;
        customToastMessage(context: context, desc: response.data["data"]);
      }
      onSubmit();
      updatingPortfolio();
    } on DioException catch (error) {
      updatingPortfolio();
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.response?.data["data"]);
    } catch (error) {
      updatingPortfolio();
      if (!context.mounted) return;
      customToastMessage(context: context, desc: error.toString());
    }
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
