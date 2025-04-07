import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../routes.dart';
class AdminDrawer extends StatelessWidget {
  final String currentRoute;
  final Function(String) navigateTo;

  const AdminDrawer({
    super.key,
    required this.currentRoute,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 250,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF8E24AA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              "assets/images/maybach_banner_2.png",
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildNavItem(Icons.dashboard, "Dashboard",'/admin'),
                 // _buildNavItem(Icons.account_balance, "Deposit", '/deposit'),
                  _buildExpandableTile(
                    context,
                    Icons.card_giftcard,
                    "Packages",
                    {
                      "Silver": '/silver-package',
                      "Platinum": '/platinum-package',
                      "Gold": '/gold-package',
                    },
                  ),
                  _buildNavItem(Icons.notifications, "Notifications",'/notification'),
                  _buildNavItem(Icons.ads_click, "Ads",'/upload_ads'),

                  // _buildExpandableTile(
                  //   context,
                  //   Icons.attach_money,
                  //   "MoneyZone",
                  //   {
                  //     "Submit Views": '/submit-views',
                  //     "Whatsup Withdrawals": '/whatsup-withdrawals',
                  //     "Bonus Withdrawals": '/bonus-withdrawals',
                  //   },
                  // ),
                  // _buildExpandableTile(
                  //   context,
                  //   Icons.money,
                  //   "Dolar Zone",
                  //   {
                  //     "Certification": '/certification',
                  //     "Advertising Agent": '/advertising-agent',
                  //     "Verification": '/verification',
                  //   },
                  // ),
                  // _buildExpandableTile(
                  //   context,
                  //   Icons.favorite,
                  //   "Bonuses",
                  //   {
                  //     "Welcome Bonus": '/welcome-bonus',
                  //     "Cashback Bonus": '/cashback-bonus',
                  //     "Pro Bonus": '/pro-bonus',
                  //   },
                  // ),
                  // _buildExpandableTile(
                  //   context,
                  //   Icons.edit,
                  //   "Online Writing",
                  //   {
                  //     "Remotasks": '/remotasks',
                  //     "Cloudworkers": '/cloudworkers',
                  //   },
                  // ),
                  // _buildNavItem(Icons.star, "Starlink", '/starlink'),
                  // _buildNavItem(Icons.monetization_on, "Monetized Ads", '/monetized-ads'),
                  // _buildNavItem(Icons.work, "Jobs", '/jobs'),
                  // _buildExpandableTile(
                  //   context,
                  //   Icons.credit_card,
                  //   "Loans",
                  //   {
                  //     "Apply": '/apply',
                  //     "History": '/history',
                  //   },
                  // ),
                  // _buildNavItem(Icons.security, "Clearance", '/clearance'),
                  // _buildNavItem(Icons.people, "Teams", '/teams'),
                 // _buildNavItem(Icons.settings, "Settings", '/settings'),
                  const Divider(color: Colors.white70),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app, color: Colors.white),
                    title: const Text("Logout", style: TextStyle(color: Colors.white)),
                    onTap: () async {
                      // Clear secure storage data
                      const storage = FlutterSecureStorage();
                      await storage.deleteAll();
                      if (kDebugMode) {
                        print("data deleted");
                      }

                      // Manually reset the URL to /login
                      if (kIsWeb) {
                        html.window.history.pushState(null, '', '/login'); // Reset to login URL
                      }

                      // Navigate to the login page and remove all previous routes
                      Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
                    },
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      tileColor: currentRoute == route ? Colors.purple.withOpacity(0.3) : null,
      onTap: () {
        navigateTo(route);
      },
    );
  }

  Widget _buildExpandableTile(BuildContext context, IconData icon, String title, Map<String, String> subRoutes) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        children: subRoutes.entries.map((entry) => Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: _buildNavItem(Icons.circle, entry.key, entry.value),
        )).toList(),
      ),
    );
  }
}