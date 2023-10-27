import 'dart:convert';
import 'package:assignment_12/core/app_export.dart';
import 'package:assignment_12/screens/add_blog_screen.dart';
import 'package:assignment_12/screens/blog_details_screen.dart';
import 'package:assignment_12/screens/blog_list_screen.dart';
import 'package:assignment_12/screens/contact_form_screen.dart';
import 'package:assignment_12/screens/edit_profile_screen.dart';
import 'package:assignment_12/screens/edit_projects_screen.dart';
import 'package:assignment_12/screens/login_screen.dart';
import 'package:assignment_12/screens/portfolio_details_screen.dart';
import 'package:assignment_12/screens/portfolio_list_screen.dart';
import 'package:assignment_12/screens/profile_screen.dart';
import 'package:assignment_12/screens/signup_screen.dart';
import 'package:assignment_12/screens/splash_screen.dart';
import 'package:assignment_12/screens/web_view_screen.dart';

final GoRouter router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: [
        GoRoute(
          path: 'login',
          name: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: 'signup',
          name: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignupScreen();
          },
        ),
        GoRoute(
          path: 'contact',
          name: 'contact',
          builder: (BuildContext context, GoRouterState state) {
            return ContactFormScreen(
              receiver: jsonEncode(state.extra),
            );
          },
        ),
        GoRoute(
          path: 'portfolio',
          name: 'portfolio',
          builder: (BuildContext context, GoRouterState state) {
            return const PortfolioScreen();
          },
        ),
        GoRoute(
          path: 'portfolio_details',
          name: 'portfolio_details',
          builder: (BuildContext context, GoRouterState state) {
            return PortfolioDetailsScreen(
              userId: jsonEncode(state.extra),
            );
          },
        ),
        GoRoute(
          path: 'blog',
          name: 'blog',
          builder: (BuildContext context, GoRouterState state) {
            return const BlogScreen();
          },
        ),
        GoRoute(
          path: 'add_blog',
          name: 'add_blog',
          builder: (BuildContext context, GoRouterState state) {
            return AddBlogScreen(
              blog: jsonEncode(state.extra),
            );
          },
        ),
        GoRoute(
          path: 'blog_details',
          name: 'blog_details',
          builder: (BuildContext context, GoRouterState state) {
            return const BlogDetailsScreen();
          },
        ),
        GoRoute(
          path: 'web_view',
          name: 'web_view',
          builder: (BuildContext context, GoRouterState state) {
            return WebViewScreen(
              initialUri: jsonEncode(state.extra),
            );
          },
        ),
        GoRoute(
          path: 'profile',
          name: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
        ),
        GoRoute(
          path: 'edit_profile',
          name: 'edit_profile',
          builder: (BuildContext context, GoRouterState state) {
            return const EditProfileScreen();
          },
        ),
        GoRoute(
          path: 'edit_projects',
          name: 'edit_projects',
          builder: (BuildContext context, GoRouterState state) {
            return const EditProjectsScreen();
          },
        ),
      ],
    ),
  ],
);
