import 'package:QuickTicket/screens/widgets/app_bar.dart';
import 'package:QuickTicket/screens/widgets/search_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSection(title: "Quick Ticket"),
      body: SafeArea(child: _HomeBody()),
        backgroundColor: Color(0xFFEDEDED),
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
          SearchSection()
        ],
      ),
    );
  }
  
  
}