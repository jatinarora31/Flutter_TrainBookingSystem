import 'package:QuickTicket/repositories/station_repository.dart';
import 'package:QuickTicket/router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/station_cubit.dart';
import 'network/token_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TokenService.loadUserData();
  runApp(const MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => StationCubit(StationRepository()),
        ),
      ],
      child: MaterialApp.router(routerConfig: appRouter, debugShowCheckedModeBanner: false,),
    );
  }
}
