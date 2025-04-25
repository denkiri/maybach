import 'package:flutter/material.dart';
import 'package:flutter_projects/viewmodel/account_viewmodel.dart';
import 'package:flutter_projects/viewmodel/ad_viewmodel.dart';
import 'package:flutter_projects/viewmodel/auth_viewmodel.dart';
import 'package:flutter_projects/viewmodel/dashboard_viewmodel.dart';
import 'package:flutter_projects/viewmodel/deposit_viewmodel.dart';
import 'package:flutter_projects/viewmodel/job_viewmodel.dart';
import 'package:flutter_projects/viewmodel/loan_viewmodel.dart';
import 'package:flutter_projects/viewmodel/notification_viewmodel.dart';
import 'package:flutter_projects/viewmodel/package_viewmodel.dart';
import 'package:flutter_projects/viewmodel/submit_views_view_model.dart';
import 'package:flutter_projects/viewmodel/teams_viewmodel.dart';
import 'package:flutter_projects/viewmodel/whatsup_withdrawal_viewmodel.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => PackageViewModel()),
        ChangeNotifierProvider(create: (_) => JobViewModel()),
        ChangeNotifierProvider(create: (_) => DepositViewModel()),
        ChangeNotifierProvider(create: (_) => LoanViewModel()),
        ChangeNotifierProvider(create: (_) => TeamsViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => SubmitViewsViewModel()),
        ChangeNotifierProvider(create: (_) => WithdrawViewModel()),
        ChangeNotifierProvider(create: (_) => AdViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => AccountViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maybach Motors',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      initialRoute: Routes.login,
      routes: Routes.routes,
    );
  }
}
