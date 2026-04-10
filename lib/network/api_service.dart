import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import '../models/schedule_detail.dart';
import '../models/schedule_response.dart';
import '../models/station_response.dart';

part 'api_service.g.dart';
//192.168.0.105
//172.30.1.49
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

  @POST("/bookings")
  Future<dynamic> createBooking(@Body() Map<String, dynamic> bookingData);

  @GET("/bookings")
  Future<dynamic> getUserBookings();

}
