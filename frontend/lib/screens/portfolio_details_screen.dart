import 'dart:convert';
import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/providers/portfolio_provider.dart';
import 'package:assignment_12/providers/user_provider.dart';

class PortfolioDetailsScreen extends StatelessWidget {
  const PortfolioDetailsScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final uId = jsonDecode(userId);
    final userProvider = Provider.of<UserProvider>(context);
    final portfolioProvider = Provider.of<PortfolioProvider>(context);
    final currentUser = userProvider.users[uId];
    return Scaffold(
      backgroundColor: WhiteColor.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: BlackColor.matte,
          ),
        ),
        title: customTitleText(
          text: "Portfolio",
          fontSize: getFontSize(30),
          color: AppColor.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: WhiteColor.white,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () {
              context.pushNamed("contact", extra: currentUser);
            },
            child: Padding(
              padding: EdgeInsets.only(right: getHorizontalSize(10)),
              child: Icon(
                Icons.contact_page_outlined,
                color: AppColor.primaryColor,
                size: getFontSize(30),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(getSize(20)),
        width: width,
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
                  Row(
                    children: [
                      Container(
                        decoration: AppDecoration.containerBoxDecoration(),
                        child: customImageView(
                          url: currentUser?.profilePictureUrl ??
                              Defaults.defaultProfileImage,
                          imgHeight: getVerticalSize(120),
                          imgWidth: getHorizontalSize(120),
                          isAssetImage: currentUser?.profilePictureUrl == null,
                        ),
                      ),
                      SizedBox(
                        width: getHorizontalSize(15),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: getVerticalSize(5),
                          ),
                          customText(
                              text: currentUser!.username,
                              color: AppColor.primaryColor,
                              fontSize: getFontSize(25),
                              fontWeight: FontWeight.bold),
                          customText(
                              text: currentUser.email,
                              color: GrayColor.gray,
                              fontSize: getFontSize(20),
                              fontWeight: FontWeight.bold),
                          if (currentUser.contactDetails?.isNotEmpty ?? false)
                            customText(
                                text: formatPhoneNumber(
                                  currentUser.contactDetails ?? "",
                                ),
                                color: GrayColor.gray,
                                fontSize: getFontSize(20),
                                fontWeight: FontWeight.bold),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: getVerticalSize(10),
                  ),
                  customText(
                    textAlign: TextAlign.justify,
                    text: currentUser.bio ?? defaultBio,
                    color: BlackColor.matte,
                    fontSize: getFontSize(20),
                    fontWeight: FontWeight.w300,
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: getVerticalSize(10),
                  ),
                  if (portfolioProvider.isPortfolioFetching)
                    Center(
                      child: customPageLoadingAnimation(
                        size: getSize(50),
                      ),
                    ),
                  if (portfolioProvider.portfolios.isEmpty &&
                      !portfolioProvider.isPortfolioFetching)
                    customText(
                      text: emptyPortfolio,
                      maxLines: 2,
                      fontSize: getFontSize(25),
                      color: AppColor.primaryColor,
                    ),
                  if (portfolioProvider.portfolios.isNotEmpty)
                    Center(
                      child: customTitleText(
                        text: "Projects",
                        fontWeight: FontWeight.bold,
                        fontSize: getFontSize(25),
                        color: AppColor.primaryColor,
                      ),
                    ),
                  SizedBox(
                    height: getVerticalSize(10),
                  ),
                  ListView.separated(
                    itemBuilder: (context, index) {
                      final currentPortfolio =
                          portfolioProvider.portfolios[index];
                      return Container(
                        decoration: AppDecoration.containerBoxDecoration(),
                        child: ExpansionTile(
                          shape: Border(),
                          title: customText(
                            textAlign: TextAlign.start,
                            text: currentPortfolio.title,
                            color: OrangeColor.persimmonOrange,
                            fontSize: getFontSize(23),
                            fontWeight: FontWeight.w500,
                          ),
                          initiallyExpanded: false,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
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
                                        color: BlackColor.matte,
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
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: portfolioProvider.portfolios.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: getVerticalSize(20),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
