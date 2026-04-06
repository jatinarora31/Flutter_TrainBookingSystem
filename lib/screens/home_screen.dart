import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_ticket/screens/search_screen.dart';
import 'package:quick_ticket/screens/widgets/app_bar.dart';
import 'package:quick_ticket/screens/widgets/header_row.dart';
import 'package:quick_ticket/screens/widgets/search_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSection(title: "Quick Ticket"),
      body: SafeArea(child: _HomeBody())
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          HeaderRow(),
          SizedBox(height: 20),
          SearchSection()
        ],
      ),
    );
  }
  
  
}