import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/history_screen.dart';
import '../presentation/screens/profile_screen.dart';
import '../presentation/screens/scanner_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/history',
  routes: [
    // ShellRoute for BottomNavigationBar
    ShellRoute(
      navigatorKey: GlobalKey<NavigatorState>(),
      builder: (context, state, child) {
        return BottomNavigationWrapper(child: child);
      },
      routes: [
        GoRoute(
          path: '/history',
          name: 'history',
          builder: (context, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    // Route for the ScannerScreen
    GoRoute(
      path: '/scanner',
      name: 'scanner',
      builder: (context, state) => const ScannerScreen(),
    ),
  ],
);

class BottomNavigationWrapper extends StatefulWidget {
  final Widget child;

  const BottomNavigationWrapper({super.key, required this.child});

  @override
  _BottomNavigationWrapperState createState() => _BottomNavigationWrapperState();
}

class _BottomNavigationWrapperState extends State<BottomNavigationWrapper> {
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
        onPressed: () => router.push('/scanner'),
        heroTag: 'scannerFab',
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}