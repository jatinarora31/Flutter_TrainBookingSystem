import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarSection extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppBarSection({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF2A80D8),
      iconTheme: IconThemeData(color: Colors.white),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Row(
          children: [
            Container(
              width: 37,height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Icon(Icons.train_rounded,color: Color(0xFF2A80D8),),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3
              ),
            ),
            const Spacer()
          ],
        ),
      )
    );
  }
}