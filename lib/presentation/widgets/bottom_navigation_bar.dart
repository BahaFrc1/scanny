import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/keys.dart';
import '../screens/history_screen.dart';
import '../screens/profile_screen.dart';

class BottomNavigationWrapper extends StatefulWidget {
  final Widget child;

  const BottomNavigationWrapper({super.key, required this.child});

  @override
  BottomNavigationWrapperState createState() => BottomNavigationWrapperState();
}

class BottomNavigationWrapperState extends State<BottomNavigationWrapper> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final iconList = <IconData>[
    Icons.history,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter.of(context);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          HistoryScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        activeColor: Colors.deepPurpleAccent,
        inactiveColor: Colors.grey,
        leftCornerRadius: 20,
        rightCornerRadius: 20,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => router.push(routeScanner),
        heroTag: 'scannerFab',
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
