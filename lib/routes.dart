import 'package:flutter/material.dart';
import 'package:flutter_projects/pages/auth/change_password.dart';
import 'package:flutter_projects/pages/auth/login.dart';
import 'package:flutter_projects/pages/auth/signup.dart';
import 'package:flutter_projects/pages/dashboard/admin.dart';
import 'package:flutter_projects/pages/dashboard/dashboard.dart';
class Routes {
  Routes._();
  static const String login = '/login';
  static const String signup = '/signup';
  static const String changePassword = '/changePassword';
  static const String dashboard ='/dashboard';
  static const String admin ='/admin';

  static final Map<String, WidgetBuilder> routes = {
    login: (_) => Login(),
    signup: (_) => Signup(),
    changePassword: (_) => ChangePassword(),
    dashboard: (_) => const DashboardScreen(),
    admin: (_) => const AdminDashboardScreen(),
  };

}
