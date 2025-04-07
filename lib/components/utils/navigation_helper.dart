import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../pages/auth/login.dart';
import '../../pages/dashboard/dashboard.dart';
import '../../routes.dart';

class NavigationHelper {
  static void clearAllAndGoTo(BuildContext context, String routeName) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => _generateRoute(routeName)),
          (Route<dynamic> route) => false,
    );
  }

  static Widget _generateRoute(String routeName) {
    switch (routeName) {
      case Routes.login:
        return Login();
      case Routes.dashboard:
        return const DashboardScreen();
    // Add all other routes
      default:
        return  Login();
    }
  }
}