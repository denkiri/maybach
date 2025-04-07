import 'package:flutter/material.dart';

import '../../../components/widgets/app_colors.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLargeScreen;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar({
    super.key,
    required this.isLargeScreen,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight), // Standard AppBar height
      child: Container(
        decoration: const BoxDecoration(
        gradient: AppGradients.bluePurpleGradient,
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,// Transparent to show gradient
          elevation: 0, // Removes AppBar shadow
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "",
            style: TextStyle(color: Colors.white),
          ),
          leading: isLargeScreen
              ? null // No leading icon on large screens
              : IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              scaffoldKey.currentState?.openDrawer(); // Open the drawer
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(60);
}