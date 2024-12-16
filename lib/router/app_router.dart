import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/keys.dart';
import '../presentation/screens/history_screen.dart';
import '../presentation/screens/profile_screen.dart';
import '../presentation/screens/scanner_screen.dart';
import '../presentation/widgets/bottom_navigation_bar.dart';

final appRouter = GoRouter(
  initialLocation: routeHistory,
  routes: [
    ShellRoute(
      navigatorKey: GlobalKey<NavigatorState>(),
      builder: (context, state, child) {
        return BottomNavigationWrapper(child: child);
      },
      routes: [
        GoRoute(
          path: routeHistory,
          name: 'history',
          builder: (context, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: routeProfile,
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: routeScanner,
      name: 'scanner',
      builder: (context, state) => const ScannerScreen(),
    ),
  ],
);
