import 'package:go_router/go_router.dart';
import 'package:quick_ticket/screens/booking_screen.dart';
import '../network/token_service.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/main_screen.dart';
import '../screens/my_booking.dart';
import '../screens/schedule_screen.dart';
import '../screens/search_screen.dart';
import '../screens/widgets/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/register',

  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
          routes: [
            GoRoute(
              path: "/search",
              builder: (context, state) {
                final type = state.extra as String?;
                return SearchScreen(type: type ?? '');
              },
            ),
            GoRoute(
              path: '/schedules',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>;
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
                  path: '/book',
                  builder: (context,state) {
                    final extra = state.extra as Map<String,dynamic>;
                    return BookingScreen(
                      scheduleId: extra['scheduleId'],
                      srcStationId: extra['srcStationId'],
                      dstStationId: extra['dstStationId'],
                      srcStationName: extra['srcStationName'],
                      dstStationName: extra['dstStationName'],
                      travelDate: extra['travelDate'],
                    );
                  }
                )
              ]
            )
          ],
        ),

        GoRoute(
          path: '/my_booking',
          builder: (context, state) => MyBooking(),
        ),

        GoRoute(
          path: '/profile',
          builder: (context, state) {
            final isLoggedIn = TokenService.isLoggedInSync();

            return isLoggedIn
                ? ProfileScreen()
                : LoginScreen();
          },
        ),

        GoRoute(
          path: '/login',
          builder: (context, state) => LoginScreen(),
        ),

        GoRoute(
          path: '/register',
          builder: (context, state) => RegisterScreen(),
        ),

        GoRoute(
          path: '/home/schedules',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            return ScheduleScreen(
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
);