import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/providers/portfolio_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              text: "Profile",
              fontSize: getFontSize(30),
              color: AppColor.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        backgroundColor: WhiteColor.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(
          getSize(20),
        ),
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => FadeInAnimation(
                delay: const Duration(milliseconds: 100),
                child: SlideAnimation(
                  horizontalOffset: -50.0,
                  delay: const Duration(milliseconds: 60),
                  child: widget,
                ),
              ),
              children: [
                Row(
                  children: [
                    Container(
                      decoration: AppDecoration.containerBoxDecoration(),
                      child: customImageView(
                        url: currentUserDetails.profilePictureUrl ??
                            Defaults.defaultProfileImage,
                        imgHeight: getVerticalSize(120),
                        imgWidth: getHorizontalSize(120),
                        isAssetImage:
                            currentUserDetails.profilePictureUrl == null,
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
                            text: currentUserDetails.username,
                            color: AppColor.primaryColor,
                            fontSize: getFontSize(25),
                            fontWeight: FontWeight.bold),
                        customText(
                            text: currentUserDetails.email,
                            color: GrayColor.gray,
                            fontSize: getFontSize(20),
                            fontWeight: FontWeight.bold),
                        if (currentUserDetails.contactDetails?.isNotEmpty ??
                            false)
                          customText(
                              text: formatPhoneNumber(
                                currentUserDetails.contactDetails ?? "",
                              ),
                              color: GrayColor.gray,
                              fontSize: getFontSize(20),
                              fontWeight: FontWeight.bold),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: getVerticalSize(20),
                ),
                ListTile(
                  onTap: () {
                    context.pushNamed("edit_profile");
                  },
                  title: customText(
                    textAlign: TextAlign.start,
                    text: "Edit Profile",
                    fontSize: getFontSize(20),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: GrayColor.gray,
                    size: getFontSize(20),
                  ),
                  leading: Icon(
                    Icons.person_add_alt_outlined,
                    color: GrayColor.gray,
                    size: getFontSize(30),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Provider.of<PortfolioProvider>(context, listen: false)
                        .getUserPortfolios(
                      context: context,
                      uid: currentUserDetails.id.toString(),
                    );
                    context.pushNamed("edit_projects");
                  },
                  title: customText(
                    textAlign: TextAlign.start,
                    text: "Edit Projects",
                    fontSize: getFontSize(20),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: GrayColor.gray,
                    size: getFontSize(20),
                  ),
                  leading: Icon(
                    Icons.business_center_outlined,
                    color: GrayColor.gray,
                    size: getFontSize(30),
                  ),
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return alertDialog(
                          context: context,
                        );
                      },
                    );
                  },
                  title: customText(
                    textAlign: TextAlign.start,
                    text: "Logout",
                    fontSize: getFontSize(20),
                    color: RedColor.cardinalRed,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: RedColor.cardinalRed,
                    size: getFontSize(20),
                  ),
                  leading: Icon(
                    Icons.logout_rounded,
                    color: RedColor.cardinalRed,
                    size: getFontSize(30),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}

Widget alertDialog({
  required BuildContext context,
  // required ProfileProvider profileProvider,
}) {
  return AlertDialog(
    title: customTitleText(
      text: "Alert",
      color: AppColor.primaryColor,
      fontSize: getFontSize(22),
      fontWeight: FontWeight.bold,
    ),
    content: customText(
      text: "Are you sure want to logout?",
      color: BlackColor.charcoalBlack,
      fontSize: getFontSize(18),
    ),
    shape: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    actions: [
      TextButton(
        onPressed: () {
          context.pop();
        },
        child: Container(
          padding: EdgeInsets.all(getSize(14)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: customText(
            text: "Cancel",
            fontSize: getFontSize(15),
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          clearStorage();
          context.goNamed("login");
          selectedBottomNavigationIndex = 0;
        },
        child: Container(
          padding: EdgeInsets.all(getSize(14)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                RedColor.cadmiumRed,
                RedColor.bloodRed,
              ],
            ),
          ),
          child: customText(
            text: "Logout",
            fontSize: getFontSize(15),
            color: WhiteColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}
