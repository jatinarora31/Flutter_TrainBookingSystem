// booking_repository.dart
import '../network/api_service.dart';
import '../network/dio_client.dart';

class BookingRepository {
  late final ApiService _api;

  BookingRepository() {
    _api = ApiService(DioClient.getDio());
  }

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await _api.createBooking(bookingData);
      return response;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  Future<Map<String, dynamic>> fetchUserBookings() async {
    try {
      final response = await _api.getUserBookings();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }

}