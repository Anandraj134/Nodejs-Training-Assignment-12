import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/providers/portfolio_provider.dart';

class EditProjectsScreen extends StatelessWidget {
  const EditProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = Provider.of<PortfolioProvider>(context);
    return Scaffold(
      backgroundColor: WhiteColor.white,
      appBar: AppBar(
        backgroundColor: WhiteColor.white,
        elevation: 0,
        centerTitle: true,
        title: customText(
          text: "Edit Projects",
          fontSize: getFontSize(25),
        ),
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: BlackColor.charcoalBlack,
          ),
        ),
      ),
      body: Column(
        children: [
          if (portfolioProvider.isPortfolioFetching)
            Center(
              child: customPageLoadingAnimation(
                size: getSize(50),
              ),
            ),
          if (portfolioProvider.portfolios.isEmpty &&
              !portfolioProvider.isPortfolioFetching)
            Center(
              child: customText(
                text: emptyPortfolio,
                fontSize: getFontSize(25),
                fontWeight: FontWeight.bold,
                maxLines: 3,
              ),
            ),
          ListView.separated(
            padding: EdgeInsets.all(
              getSize(20),
            ),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final currentPortfolio = portfolioProvider.portfolios[index];
              return Container(
                decoration: AppDecoration.containerBoxDecoration(),
                child: ExpansionTile(
                  shape: const Border(),
                  initiallyExpanded: false,
                  title: customText(
                    textAlign: TextAlign.start,
                    text: currentPortfolio.title,
                    color: OrangeColor.persimmonOrange,
                    fontSize: getFontSize(23),
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    portfolioProvider.onEdit(
                                      title: currentPortfolio.title,
                                      desc: currentPortfolio.description,
                                      tech: currentPortfolio.technologiesUsed,
                                      githubLink: currentPortfolio.githubLink,
                                    );
                                    showModalBottomSheet(
                                      shape: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(25),
                                          topLeft: Radius.circular(25),
                                        ),
                                      ),
                                      backgroundColor: WhiteColor.white,
                                      elevation: 10,
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => editBottomSheet(
                                        context: context,
                                        isEdit: true,
                                        id: currentPortfolio.id.toString(),
                                      ),
                                    );
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
                                    portfolioProvider.deletePortfolio(
                                      context: context,
                                      id: currentPortfolio.id.toString(),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.delete_rounded,
                                    color: RedColor.cardinalRed,
                                  ),
                                ),
                              ],
                            ),
                            customText(
                              text: "Description: ",
                              color: AppColor.primaryColor,
                              textAlign: TextAlign.start,
                              fontSize: getFontSize(20),
                            ),
                            customText(
                              text: currentPortfolio.description,
                              color: BlackColor.matte,
                              textAlign: TextAlign.justify,
                              maxLinesEnabled: true,
                            ),
                            SizedBox(
                              height: getVerticalSize(10),
                            ),
                            customText(
                              text: "Technology Used:",
                              color: AppColor.primaryColor,
                              textAlign: TextAlign.start,
                              fontSize: getFontSize(20),
                            ),
                            customText(
                              text: currentPortfolio.technologiesUsed,
                              color: BlackColor.matte,
                              textAlign: TextAlign.start,
                              maxLinesEnabled: true,
                            ),
                            SizedBox(
                              height: getVerticalSize(10),
                            ),
                            customText(
                              text: "Github Link: ",
                              fontSize: getFontSize(20),
                              color: AppColor.primaryColor,
                              textAlign: TextAlign.start,
                            ),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(
                                  "web_view",
                                  extra: currentPortfolio.githubLink,
                                );
                              },
                              child: customText(
                                needUnderline: true,
                                text: currentPortfolio.githubLink,
                                color: BlueColor.brightBlue,
                                maxLinesEnabled: true,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: getVerticalSize(20),
              );
            },
            itemCount: portfolioProvider.portfolios.length,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          portfolioProvider.onSubmit();
          showModalBottomSheet(
              shape: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
              ),
              backgroundColor: WhiteColor.white,
              elevation: 10,
              context: context,
              isScrollControlled: true,
              builder: (context) => editBottomSheet(context: context));
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

Widget editBottomSheet(
    {required BuildContext context, bool isEdit = false, String id = ""}) {
  final portfolioProvider = Provider.of<PortfolioProvider>(context);
  return Padding(
    padding: EdgeInsets.only(
      left: getHorizontalSize(20),
      right: getHorizontalSize(20),
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: getVerticalSize(20),
          ),
          Container(
            decoration: AppDecoration.inputBoxDecorationShadow(),
            child: TextFormField(
              style: AppStyle.textFormFieldStyle(),
              controller: portfolioProvider.titleController,
              decoration: AppDecoration().textInputDecorationWhite(
                icon: Icons.title_outlined,
                lableText: "Title",
                hintText: "Enter Title Here",
              ),
            ),
          ),
          SizedBox(
            height: getVerticalSize(15),
          ),
          Container(
            decoration: AppDecoration.inputBoxDecorationShadow(),
            child: TextFormField(
              style: AppStyle.textFormFieldStyle(),
              maxLines: null,
              controller: portfolioProvider.descriptionController,
              decoration: AppDecoration().textInputDecorationWhite(
                lableText: "Description",
                icon: Icons.description_outlined,
                hintText: "Enter Description Here",
              ),
            ),
          ),
          SizedBox(
            height: getVerticalSize(15),
          ),
          Container(
            decoration: AppDecoration.inputBoxDecorationShadow(),
            child: TextFormField(
              style: AppStyle.textFormFieldStyle(),
              controller: portfolioProvider.technologyController,
              decoration: AppDecoration().textInputDecorationWhite(
                icon: Icons.military_tech_outlined,
                lableText: "Technologies",
                hintText: "Enter Used Technologies Here",
              ),
            ),
          ),
          SizedBox(
            height: getVerticalSize(15),
          ),
          Container(
            decoration: AppDecoration.inputBoxDecorationShadow(),
            child: TextFormField(
              style: AppStyle.textFormFieldStyle(),
              controller: portfolioProvider.githubController,
              decoration: AppDecoration().textInputDecorationWhite(
                lableText: "Github Repository Link",
                icon: Icons.link_rounded,
                hintText: "Enter Github Repository Link Here",
              ),
            ),
          ),
          SizedBox(
            height: getVerticalSize(20),
          ),
          GestureDetector(
            onTap: () {
              portfolioProvider.editPortfolio(
                  context: context, isEdit: isEdit, id: id);
            },
            child: Container(
              height: getVerticalSize(50),
              decoration: AppDecoration.buttonBoxDecoration(),
              child: Center(
                child: portfolioProvider.isPortfolioUpdating
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
          SizedBox(
            height: getVerticalSize(20),
          ),
        ],
      ),
    ),
  );
}
