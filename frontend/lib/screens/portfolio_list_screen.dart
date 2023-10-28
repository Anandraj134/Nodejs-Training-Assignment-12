import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/providers/portfolio_provider.dart';
import 'package:assignment_12/providers/user_provider.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUserProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      backgroundColor: WhiteColor.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              text: "Portfolio",
              fontSize: getFontSize(30),
              color: AppColor.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        backgroundColor: WhiteColor.white,
        elevation: 0,
      ),
      body: AnimationLimiter(
        child: userProvider.users.length <= 1
            ? Center(
                child: customText(
                  text: noPortfolio,
                  maxLines: 3,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                  fontSize: getFontSize(25),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(
                  getSize(20),
                ),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final currentUser =
                      userProvider.users.entries.elementAt(index).value;
                  if (currentUser.id == currentUserProvider.userId) {
                    return const SizedBox();
                  }
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: FadeInAnimation(
                      delay: const Duration(milliseconds: 100),
                      child: SlideAnimation(
                        horizontalOffset: -50.0,
                        delay: const Duration(milliseconds: 60),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Provider.of<PortfolioProvider>(context,
                                        listen: false)
                                    .getUserPortfolios(
                                  context: context,
                                  uid: currentUser.id.toString(),
                                );
                                context.pushNamed("portfolio_details",
                                    extra: currentUser.id.toString());
                              },
                              child: Container(
                                decoration:
                                    AppDecoration.containerBoxDecoration(),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: GrayColor.lightGray,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: customImageView(
                                        url: currentUser.profilePictureUrl ??
                                            Defaults.defaultProfileImage,
                                        imgHeight: getSize(110),
                                        imgWidth: getSize(100),
                                        isAssetImage:
                                            currentUser.profilePictureUrl ==
                                                null,
                                      ),
                                    ),
                                    SizedBox(
                                      width: getHorizontalSize(10),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customText(
                                          text: currentUser.username,
                                          fontWeight: FontWeight.bold,
                                          fontSize: getFontSize(25),
                                          color: AppColor.primaryColor,
                                        ),
                                        SizedBox(
                                          width: getHorizontalSize(250),
                                          child: customText(
                                            text: currentUser.bio == null
                                                ? defaultBio
                                                : currentUser.bio ?? "",
                                            fontSize: getFontSize(18),
                                            fontWeight: FontWeight.w300,
                                            color: GrayColor.slatGray,
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                        customText(
                                          text: currentUser.email,
                                          fontSize: getFontSize(20),
                                          fontWeight: FontWeight.w600,
                                          color: GrayColor.gray,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getVerticalSize(15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: userProvider.users.length,
              ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
