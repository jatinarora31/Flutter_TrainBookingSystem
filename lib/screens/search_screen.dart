import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_ticket/cubit/station_cubit.dart';
import 'package:quick_ticket/repositories/station_repository.dart';
import 'package:quick_ticket/screens/widgets/app_bar.dart';
import 'package:quick_ticket/states/station_state.dart';

class SearchScreen extends StatefulWidget {
  final String type;
  const SearchScreen({super.key, required this.type});
  State<SearchScreen> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
        StationCubit(StationRepository())
          ..fetchStations(),
        child: Scaffold(
          appBar: AppBarSection(title: "Search"),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: "Search station or city...",
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<StationCubit,StationState> (
                  builder:(context,state) {
                    if (state is StationLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is StationLoaded) {
                      return ListView.builder(
                        itemCount: state.stations.length,
                        itemBuilder: (context, index) {
                          final station = state.stations[index];
                          return ListTile(
                            title: Text(station.name),
                            onTap: () {
                              context.pop(station);
                            } ,
                          );
                        },
                      );
                    }

                    if (state is StationError) {
                      return Center(child: Text(state.message));
                    }

                    return const SizedBox();
                  }
                )
              )
            ],
          ),
        )
    );
  }
}

