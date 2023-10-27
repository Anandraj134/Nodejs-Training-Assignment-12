import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/providers/blog_provider.dart';
import 'package:assignment_12/providers/user_provider.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CustomBottomNavigationState();
  }
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.06,
      child: Theme(
        data: ThemeData(
          canvasColor: WhiteColor.white,
        ),
        child: BottomNavigationBar(
          unselectedItemColor: Colors.black54,
          selectedItemColor: AppColor.primaryColor,
          elevation: 0.0,
          selectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.shifting,
          currentIndex: selectedBottomNavigationIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.business_center_outlined,
                color: Colors.black,
              ),
              activeIcon: activeIconBuilder(
                icon: Icons.business_center_rounded,
                title: "Portfolio",
                isMarginRequired: true,
              ),
              label: "Portfolio",
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.description_outlined,
                color: Colors.black,
              ),
              activeIcon: activeIconBuilder(
                icon: Icons.description_outlined,
                title: "Blog",
              ),
              label: "Blog",
            ),
            BottomNavigationBarItem(
              icon: const Icon(
                Icons.person_outline,
                color: Colors.black,
              ),
              activeIcon: activeIconBuilder(
                icon: Icons.person,
                title: "Profile",
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedBottomNavigationIndex = index;
      debugPrint("Selected Index :: $selectedBottomNavigationIndex");
      _navigateToScreens(selectedBottomNavigationIndex);
    });
  }

  // This will navigate to respective pages
  void _navigateToScreens(int index) {
    if (index == 0) {
      Provider.of<UserProvider>(context, listen: false)
          .fetchUser(context: context);
      debugPrint("Navigating to portfolio");
      context.pushReplacementNamed("portfolio");
    } else if (index == 1) {
      debugPrint("Navigating to blog");
      Provider.of<BlogProvider>(context, listen: false)
          .getBlogs(context: context);
      context.pushReplacementNamed("blog");
    } else if (index == 2) {
      debugPrint("Navigating to profile");
      context.pushReplacementNamed("profile");
    }
  }
}

Widget activeIconBuilder({
  required IconData icon,
  required String title,
  bool isMarginRequired = false,
}) {
  return Container(
    margin: isMarginRequired
        ? const EdgeInsets.only(left: 10, right: 10)
        : EdgeInsets.zero,
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
    decoration: BoxDecoration(
      color: AppColor.primaryColor,
      borderRadius: BorderRadius.circular(40),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: WhiteColor.white,
        ),
        SizedBox(
          width: getHorizontalSize(10),
        ),
        customText(
          text: title,
          color: WhiteColor.white,
        ),
      ],
    ),
  );
}
