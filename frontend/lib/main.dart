import 'package:assignment_12/providers/blog_provider.dart';
import 'package:assignment_12/providers/comment_provider.dart';
import 'package:assignment_12/providers/contact_from_provider.dart';
import 'package:assignment_12/providers/login_provider.dart';
import 'package:assignment_12/providers/portfolio_provider.dart';
import 'package:assignment_12/providers/profile_provider.dart';
import 'package:assignment_12/providers/signup_provider.dart';
import 'package:assignment_12/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:assignment_12/core/app_export.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const Blogfolio());
}

class Blogfolio extends StatelessWidget {
  const Blogfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<LoginProvider>(
          create: (context) => LoginProvider(),
        ),
        ChangeNotifierProvider<SignupProvider>(
          create: (context) => SignupProvider(),
        ),
        ChangeNotifierProvider<BlogProvider>(
          create: (context) => BlogProvider(),
        ),
        ChangeNotifierProvider<PortfolioProvider>(
          create: (context) => PortfolioProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider<CommentProvider>(
          create: (context) => CommentProvider(),
        ),
        ChangeNotifierProvider<ContactFormProvider>(
          create: (context) => ContactFormProvider(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate,
      ),
    );
  }
}
