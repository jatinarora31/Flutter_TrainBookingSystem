
import '../models/schedule_detail.dart';
import '../models/schedule_response.dart';
import '../network/api_service.dart';
import '../network/dio_client.dart';

class ScheduleRepository {
  late final ApiService _api;

  ScheduleRepository() {
    _api = ApiService(DioClient.getDio());
  }

  Future<ScheduleResponse> getAllSchedules(String srcStationId, String dstStationId, String travelDate) async {
    final result = await _api.getAllSchedules(srcStationId ,dstStationId,travelDate);
    return result;
  }

  Future<ScheduleDetail> getSchedule(String scheduleId, String srcStationId, String dstStationId) async {
    print("SCHEDULE ID --------------------------------------- $scheduleId");
    try {
      final res = await _api.getSchedule(scheduleId, srcStationId, dstStationId);
      return res;
    } catch (e) {
      print("Error fetching schedule: $e");
      rethrow;
    }
  }

}