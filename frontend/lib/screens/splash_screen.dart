import 'dart:async';
import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/providers/blog_provider.dart';
import 'package:assignment_12/providers/user_provider.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> fadeInFadeOut;
  String routeName = "";

  @override
  void initState() {
    super.initState();

    getInitData();

    animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(animation);
    animation.forward();

    Timer(
      Duration(seconds: 4),
      () => context.pushReplacementNamed(routeName),
    );
  }

  void getInitData() async {
    authToken = await readStorage(storageAuthToken) ?? "";
    currentUserDetails.id = int.parse(await readStorage(storageUserId) ?? "-1");
    if (authToken.isNotEmpty) {
      Provider.of<UserProvider>(context, listen: false)
          .fetchUser(context: context);
      routeName = "portfolio";
    } else {
      routeName = "login";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: fadeInFadeOut,
                child: customText(
                  text: "Blogfolio",
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                  fontSize: getFontSize(45),
                ),
              ),
              SizedBox(
                height: getVerticalSize(100),
              ),
              Padding(
                padding: EdgeInsets.all(getSize(20)),
                child: Lottie.asset(
                  AppImages.blogfolioSplash,
                  repeat: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
