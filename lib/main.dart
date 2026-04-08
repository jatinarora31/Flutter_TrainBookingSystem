import 'package:flutter/material.dart';
import 'package:quick_ticket/router/go_router.dart';

import 'network/token_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TokenService.loadUserData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter);
  }
}
