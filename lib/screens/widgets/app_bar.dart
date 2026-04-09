import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../booking_screen.dart';

class AppBarSection extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppBarSection({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: const Border(bottom: BorderSide(color: Colors.black, width: 0.1)),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Quick Ticket",
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      ),

    );
  }
}