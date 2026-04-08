import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_ticket/screens/booking_screen.dart';
import 'package:quick_ticket/screens/setting_screen.dart';
import '../network/token_service.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/main_screen.dart';
import '../screens/my_booking_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/search_screen.dart';
import '../screens/widgets/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: "search",
              builder: (context, state) {
                final type = state.extra as String?;
                return SearchScreen(type: type ?? '');
              },
            ),
            GoRoute(
              path: 'schedules',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                if (extra == null) {
                  return const SizedBox.shrink();
                }
                return ScheduleScreen(
                  srcStationId: extra['srcStationId'],
                  dstStationId: extra['dstStationId'],
                  srcStationName: extra['srcStationName'],
                  dstStationName: extra['dstStationName'],
                  travelDate: extra['travelDate'],
                );
              },
              routes: [
                GoRoute(
                  path: 'book',  // Note: no leading slash
                  name: 'booking', // Add a name for easier navigation
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    if (extra == null) {
                      return const SizedBox.shrink();
                    }
                    return BookingScreen(
                      scheduleId: extra['scheduleId'],
                      srcStationId: extra['srcStationId'],
                      dstStationId: extra['dstStationId'],
                      srcStationName: extra['srcStationName'],
                      dstStationName: extra['dstStationName'],
                      travelDate: extra['travelDate'],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/my_booking',
          builder: (context, state) => const MyBookingsScreen(),
        ),
        GoRoute(
          path: '/setting',
          builder: (context, state) {
            final isLoggedIn = TokenService.isLoggedInSync();
            return isLoggedIn ? const SettingsScreen() : const LoginScreen();
          },
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: '/login',
              builder: (context, state) => const LoginScreen(),
            ),
            GoRoute(
              path: '/register',
              builder: (context, state) => const RegisterScreen(),
            ),
          ]
        ),


      ],
    ),
  ],
);