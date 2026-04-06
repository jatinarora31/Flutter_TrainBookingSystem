import 'package:quick_ticket/models/station.dart';
import 'package:quick_ticket/network/api_service.dart';
import 'package:quick_ticket/network/dio_client.dart';

class StationRepository {
  late final ApiService _api;

  StationRepository() {
    _api = ApiService(DioClient.getDio());
  }

  Future<List<Station>> getAllStations() async {
    print("RES - ------------ API CALLED -----------------------");
    final res = await _api.getAllStations();
    print("RES - ------------ $res ------------------------ ${res.stations}");
    return res.stations;
  }
}