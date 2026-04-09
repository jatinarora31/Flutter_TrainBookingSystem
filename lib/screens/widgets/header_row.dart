import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quick_ticket/screens/booking_screen.dart';

class HeaderRow extends StatelessWidget {
  const HeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // color: Color(0xFF2A80D8), //white grey
          color: Color(0xFFFAFFFF),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE8E6E6).withOpacity(1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Book Train Tickets",
                    style: TextStyle(
                      // color: Colors.white, // kprimary
                      color: kPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Pill(label: "Fast"),
                      const SizedBox(width: 6),
                      _Pill(label: "Easy"),
                      const SizedBox(width: 6),
                      _Pill(label: "Secure"),
                    ],
                  ),
                ],
              ),
            ),

            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: kPrimary.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(
                  Icons.train_rounded,
                  size: 42,
                  // color: Colors.white,
                  color: kPrimary
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: kPrimary.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: kPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}