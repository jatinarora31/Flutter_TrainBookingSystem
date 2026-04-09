import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quick_ticket/repositories/station_repository.dart';
import 'package:quick_ticket/states/station_state.dart';

class StationCubit extends Cubit<StationState> {
  final StationRepository repository;
  StationCubit(this.repository) : super(StationInitial()) {
    fetchStations();
  }

  Future<void> fetchStations() async {
    print("-------------FETCH CALLED--------------");
    emit(StationLoading());
    try {
      final stations = await repository.getAllStations();
      print("-------------DATA RECEIVED: ${stations.length}");
      emit(StationLoaded(stations));
    } catch(e) {
      print("-----------ERROR: $e");
      emit(StationError(e.toString()));
    }
  }

}