import 'package:flutter/material.dart';
import 'package:weather_app/src/views/screens/home_screen.dart';
import 'package:weather_app/src/views/widgets/app_drawer.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  bool isDrawerOpen = false;

  void toggleDrawer() {
    setState(() => isDrawerOpen = !isDrawerOpen);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Drawer
          AppDrawer(onMenuTap: toggleDrawer),

          /// 🔹 Main Page (Slides)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(
              isDrawerOpen ? screenWidth * 0.65 : 0,
              isDrawerOpen ? screenHeight * 0.033 : 0,
              0,
            ),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: isDrawerOpen
                  ? [BoxShadow(color: Colors.black26, blurRadius: 20)]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),

              child: HomeScreen(onMenuTap: toggleDrawer, isDrawerOpen: isDrawerOpen),
            ),
          ),
        ],
      ),
    );
  }
}
