import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';

import '../../core/app_color.dart';
import '../../controller/main_controller.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final MainController _controller = MainController.to;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: GetBuilder<MainController>(builder: (logic) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: _controller.tabs.elementAt(_controller.selectedIndex),
          );
        }),
        bottomNavigationBar: CurvedNavBarWidget(),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_controller.selectedIndex != 0) {
      _controller.selectedIndex = 0;
      _controller.update();
      return false;
    }
    return true;
  }
}

class CurvedNavBarWidget extends StatelessWidget {
  final MainController _controller = MainController.to;

  CurvedNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: _controller.selectedIndex,
      height: 60.0,
      color: AppColor.primaryColor,
      buttonBackgroundColor: AppColor.primaryColor.withOpacity(0.5),
      backgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 300),
      onTap: (index) {

        _controller.selectedIndex = index;
        _controller.update();
      },
      items: const [
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.category, size: 30, color: Colors.white),
        Icon(Icons.shopping_cart, size: 30, color: Colors.white),
        Icon(Icons.search, size: 30, color: Colors.white),
        Icon(Icons.notifications, size: 30, color: Colors.white),
      ],
    );
  }
}
