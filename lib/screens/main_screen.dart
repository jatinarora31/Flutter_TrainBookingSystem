import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'booking_screen.dart';

class MainScreen extends StatelessWidget {
  final Widget child;
  const MainScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith('/home')) {
      currentIndex = 0;
    } else if (location.startsWith('/my_booking')) {
      currentIndex = 1;
    } else if (location.startsWith('/setting')) {
      currentIndex = 2;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kPrimary,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go("/home");
              break;
            case 1:
              context.go("/my_booking");
              break;
            case 2:
              context.go("/setting");
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}