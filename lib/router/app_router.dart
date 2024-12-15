import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/screens/history_screen.dart';
import '../presentation/screens/profile_screen.dart';
import '../presentation/screens/scanner_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/scanner',
  routes: [
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/scanner',
      name: 'scanner',
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

final appRouter2 = GoRouter(
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

class BottomNavigationWrapper extends StatelessWidget {
  final Widget child;

  const BottomNavigationWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // var position = 0;
    final GoRouter router = GoRouter.of(context);
    final currentLocation = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getSelectedIndex(currentLocation),
        onTap: (int index) {
          switch (index) {
            case 1:
              router.go('/profile');
            default:
              router.go('/history');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => router.push('/scanner'),
        heroTag: 'scannerFab',
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  int _getSelectedIndex(String location) {
    if (location.startsWith('/history')) return 0;
    if (location.startsWith('/profile')) return 1;
    return -1; // Scanner screen has no index on the bottom bar
  }
}
