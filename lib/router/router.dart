import 'package:drape_shoppe_crm/screens/auth/login_screen.dart';
import 'package:drape_shoppe_crm/screens/auth/signup_screen.dart';
import 'package:drape_shoppe_crm/screens/home/home_screen.dart';
import 'package:drape_shoppe_crm/screens/task/add_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class MyRouter {
  static GoRouter router(bool isLoggedIn) {
    return GoRouter(initialLocation: isLoggedIn ? '/home' : '/signup', routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) => HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (BuildContext context, GoRouterState state) => LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (BuildContext context, GoRouterState state) => SignupScreen(),
      ),
    ]);
  }
}
