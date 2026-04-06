import 'package:dio/dio.dart';
import 'package:quick_ticket/models/schedule_response.dart';
import 'package:quick_ticket/models/station_response.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../models/schedule_detail.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://172.30.1.49:3000")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/stations")
  Future<StationResponse> getAllStations();

  @GET("/schedules/")
  Future<ScheduleResponse> getAllSchedules(
      @Query("src_station_id") String scrStationId,
      @Query("dst_station_id") String dstStationId,
      @Query("travel_date") String travelDate
      );

  @GET("/schedules/{schedule_id}")
  Future<ScheduleDetail> getSchedule(
      @Path("schedule_id") String scheduleId,
      @Query("src_station_id") String srcStationId,
      @Query("dst_station_id") String dstStationId,
      );
}
