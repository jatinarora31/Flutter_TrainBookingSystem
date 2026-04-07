// // models/booking_response.dart
// import 'package:json_annotation/json_annotation.dart';
// import 'package:quick_ticket/models/schedule.dart';
// import 'package:quick_ticket/models/station.dart';
// import 'package:quick_ticket/models/train.dart';
//
// import 'availability.dart';
// import 'city.dart';
//
// part 'booking_response.g.dart';
//
// @JsonSerializable()
// class BookingResponse {
//   @JsonKey(name: 'message')
//   final String message;
//
//   @JsonKey(name: 'booking')
//   final BookingData booking;
//
//   BookingResponse({
//     required this.message,
//     required this.booking,
//   });
//
//   factory BookingResponse.fromJson(Map<String, dynamic> json) {
//     return BookingResponse(
//       message: json['message'] ?? 'Booking confirmed',
//       booking: BookingData.fromJson(json['booking']),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'message': message,
//     'booking': booking.toJson(),
//   };
// }
//
// @JsonSerializable()
// class BookingData {
//   @JsonKey(name: 'id')
//   final String id;
//
//   @JsonKey(name: 'user_id')
//   final String userId;
//
//   @JsonKey(name: 'schedule_id')
//   final String scheduleId;
//
//   @JsonKey(name: 'src_station_id')
//   final String srcStationId;
//
//   @JsonKey(name: 'dst_station_id')
//   final String dstStationId;
//
//   @JsonKey(name: 'booking_ref')
//   final String bookingRef;
//
//   @JsonKey(name: 'status')
//   final String status;
//
//   @JsonKey(name: 'total_fare')
//   final String totalFare;
//
//   @JsonKey(name: 'booked_at')
//   final String bookedAt;
//
//   @JsonKey(name: 'schedule')
//   final Schedule schedule;
//
//   @JsonKey(name: 'src_station')
//   final Station srcStation;
//
//   @JsonKey(name: 'dst_station')
//   final Station dstStation;
//
//   @JsonKey(name: 'passengers')
//   final List<PassengerData> passengers;
//
//   @JsonKey(name: 'ticket_allocations')
//   final List<TicketAllocation> ticketAllocations;
//
//   @JsonKey(name: 'payment')
//   final PaymentData payment;
//
//   @JsonKey(name: 'cancellations')
//   final List<dynamic> cancellations;
//
//   BookingData({
//     required this.id,
//     required this.userId,
//     required this.scheduleId,
//     required this.srcStationId,
//     required this.dstStationId,
//     required this.bookingRef,
//     required this.status,
//     required this.totalFare,
//     required this.bookedAt,
//     required this.schedule,
//     required this.srcStation,
//     required this.dstStation,
//     required this.passengers,
//     required this.ticketAllocations,
//     required this.payment,
//     required this.cancellations,
//   });
//
//   factory BookingData.fromJson(Map<String, dynamic> json) {
//     return BookingData(
//       id: json['id'] ?? '',
//       userId: json['user_id'] ?? '',
//       scheduleId: json['schedule_id'] ?? '',
//       srcStationId: json['src_station_id'] ?? '',
//       dstStationId: json['dst_station_id'] ?? '',
//       bookingRef: json['booking_ref'] ?? '',
//       status: json['status'] ?? '',
//       totalFare: json['total_fare'] ?? '0',
//       bookedAt: json['booked_at'] ?? '',
//       schedule: json['schedule'] != null
//           ? Schedule.fromJson(json['schedule'])
//           : _getDefaultSchedule(),
//       srcStation: json['src_station'] != null
//           ? Station.fromJson(json['src_station'])
//           : _getDefaultStation(),
//       dstStation: json['dst_station'] != null
//           ? Station.fromJson(json['dst_station'])
//           : _getDefaultStation(),
//       passengers: json['passengers'] != null
//           ? (json['passengers'] as List)
//           .map((p) => PassengerData.fromJson(p))
//           .toList()
//           : [],
//       ticketAllocations: json['ticket_allocations'] != null
//           ? (json['ticket_allocations'] as List)
//           .map((t) => TicketAllocation.fromJson(t))
//           .toList()
//           : [],
//       payment: json['payment'] != null
//           ? PaymentData.fromJson(json['payment'])
//           : _getDefaultPayment(),
//       cancellations: json['cancellations'] ?? [],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'user_id': userId,
//     'schedule_id': scheduleId,
//     'src_station_id': srcStationId,
//     'dst_station_id': dstStationId,
//     'booking_ref': bookingRef,
//     'status': status,
//     'total_fare': totalFare,
//     'booked_at': bookedAt,
//     'schedule': schedule.toJson(),
//     'src_station': srcStation,
//     'dst_station': dstStation,
//     'passengers': passengers.map((p) => p.toJson()).toList(),
//     'ticket_allocations': ticketAllocations.map((t) => t.toJson()).toList(),
//     'payment': payment.toJson(),
//     'cancellations': cancellations,
//   };
// }
//
// // Replace the helper methods at the bottom of booking_response.dart
//
// // Helper methods for default values
// Schedule _getDefaultSchedule() {
//   // Create a default train
//   final defaultTrain = Train(
//     id: '',
//     trainNumber: '',
//     name: '',
//     trainType: '',
//     rating: '',
//     grade: '',
//   );
//
//   // Create default availability
//   final defaultAvailability = Availability(
//     availableSeats: 0,
//     coachTypeAvailability: CoachTypeAvailability(
//       oneAc: CoachAvailability(totalActiveSeats: 0, availableSeats: 0),
//       sleeper: CoachAvailability(totalActiveSeats: 0, availableSeats: 0),
//       twoAc: CoachAvailability(totalActiveSeats: 0, availableSeats: 0),
//     ),
//   );
//
//   return Schedule(
//     id: '',
//     travelDate: '',
//     departureTime: DateTime.now(),
//     expectedArrivalTime: DateTime.now(),
//     status: '',
//     train: defaultTrain,
//     availability: defaultAvailability,
//   );
// }
//
// Train _getDefaultTrain() {
//   return Train(
//     id: '',
//     trainNumber: '',
//     name: '',
//     trainType: '',
//     rating: '',
//     grade: '',
//   );
// }
//
// Availability _getDefaultAvailability() {
//   return Availability(
//     availableSeats: 0,
//     coachTypeAvailability: CoachTypeAvailability(
//       oneAc: CoachAvailability(totalActiveSeats: 0, availableSeats: 0),
//       sleeper: CoachAvailability(totalActiveSeats: 0, availableSeats: 0),
//       twoAc: CoachAvailability(totalActiveSeats: 0, availableSeats: 0),
//     ),
//   );
// }
//
// Station _getDefaultStation() {
//   // Create a default city with all required fields
//   final defaultCity = City(
//     id: '',
//     name: '',
//     state: '',
//     country: '',
//   );
//
//   return Station(
//     id: '',
//     name: '',
//     code: '',
//     city: defaultCity,
//   );
// }
//
// PaymentData _getDefaultPayment() {
//   return PaymentData(
//     id: '',
//     bookingId: '',
//     amount: '0',
//     currency: 'INR',
//     paymentMethod: '',
//     gatewayTxnId: '',
//     status: '',
//     paidAt: null,
//   );
// }
//
// @JsonSerializable()
// class PassengerData {
//   @JsonKey(name: 'id')
//   final String id;
//
//   @JsonKey(name: 'booking_id')
//   final String bookingId;
//
//   @JsonKey(name: 'first_name')
//   final String firstName;
//
//   @JsonKey(name: 'last_name')
//   final String lastName;
//
//   @JsonKey(name: 'age')
//   final int age;
//
//   @JsonKey(name: 'gender')
//   final String gender;
//
//   @JsonKey(name: 'id_type')
//   final String idType;
//
//   @JsonKey(name: 'id_number')
//   final String idNumber;
//
//   PassengerData({
//     required this.id,
//     required this.bookingId,
//     required this.firstName,
//     required this.lastName,
//     required this.age,
//     required this.gender,
//     required this.idType,
//     required this.idNumber,
//   });
//
//   factory PassengerData.fromJson(Map<String, dynamic> json) => PassengerData(
//     id: json['id'] ?? '',
//     bookingId: json['booking_id'] ?? '',
//     firstName: json['first_name'] ?? '',
//     lastName: json['last_name'] ?? '',
//     age: json['age'] ?? 0,
//     gender: json['gender'] ?? '',
//     idType: json['id_type'] ?? '',
//     idNumber: json['id_number'] ?? '',
//   );
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'booking_id': bookingId,
//     'first_name': firstName,
//     'last_name': lastName,
//     'age': age,
//     'gender': gender,
//     'id_type': idType,
//     'id_number': idNumber,
//   };
// }
//
// @JsonSerializable()
// class TicketAllocation {
//   @JsonKey(name: 'id')
//   final String id;
//
//   @JsonKey(name: 'booking_id')
//   final String bookingId;
//
//   @JsonKey(name: 'passenger_id')
//   final String passengerId;
//
//   @JsonKey(name: 'seat_id')
//   final String seatId;
//
//   @JsonKey(name: 'schedule_id')
//   final String scheduleId;
//
//   @JsonKey(name: 'src_station_id')
//   final String srcStationId;
//
//   @JsonKey(name: 'dst_station_id')
//   final String dstStationId;
//
//   @JsonKey(name: 'src_stop_order')
//   final int srcStopOrder;
//
//   @JsonKey(name: 'dst_stop_order')
//   final int dstStopOrder;
//
//   @JsonKey(name: 'pnr')
//   final String pnr;
//
//   @JsonKey(name: 'fare')
//   final String fare;
//
//   @JsonKey(name: 'status')
//   final String status;
//
//   @JsonKey(name: 'seat')
//   final SeatData seat;
//
//   TicketAllocation({
//     required this.id,
//     required this.bookingId,
//     required this.passengerId,
//     required this.seatId,
//     required this.scheduleId,
//     required this.srcStationId,
//     required this.dstStationId,
//     required this.srcStopOrder,
//     required this.dstStopOrder,
//     required this.pnr,
//     required this.fare,
//     required this.status,
//     required this.seat,
//   });
//
//   factory TicketAllocation.fromJson(Map<String, dynamic> json) => TicketAllocation(
//     id: json['id'] ?? '',
//     bookingId: json['booking_id'] ?? '',
//     passengerId: json['passenger_id'] ?? '',
//     seatId: json['seat_id'] ?? '',
//     scheduleId: json['schedule_id'] ?? '',
//     srcStationId: json['src_station_id'] ?? '',
//     dstStationId: json['dst_station_id'] ?? '',
//     srcStopOrder: json['src_stop_order'] ?? 0,
//     dstStopOrder: json['dst_stop_order'] ?? 0,
//     pnr: json['pnr'] ?? '',
//     fare: json['fare'] ?? '0',
//     status: json['status'] ?? '',
//     seat: json['seat'] != null ? SeatData.fromJson(json['seat']) : _getDefaultSeat(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'booking_id': bookingId,
//     'passenger_id': passengerId,
//     'seat_id': seatId,
//     'schedule_id': scheduleId,
//     'src_station_id': srcStationId,
//     'dst_station_id': dstStationId,
//     'src_stop_order': srcStopOrder,
//     'dst_stop_order': dstStopOrder,
//     'pnr': pnr,
//     'fare': fare,
//     'status': status,
//     'seat': seat.toJson(),
//   };
// }
//
// @JsonSerializable()
// class SeatData {
//   @JsonKey(name: 'id')
//   final String id;
//
//   @JsonKey(name: 'coach_id')
//   final String coachId;
//
//   @JsonKey(name: 'seat_number')
//   final String seatNumber;
//
//   @JsonKey(name: 'seat_type')
//   final String seatType;
//
//   SeatData({
//     required this.id,
//     required this.coachId,
//     required this.seatNumber,
//     required this.seatType,
//   });
//
//   factory SeatData.fromJson(Map<String, dynamic> json) => SeatData(
//     id: json['id'] ?? '',
//     coachId: json['coach_id'] ?? '',
//     seatNumber: json['seat_number'] ?? '',
//     seatType: json['seat_type'] ?? '',
//   );
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'coach_id': coachId,
//     'seat_number': seatNumber,
//     'seat_type': seatType,
//   };
// }
//
// SeatData _getDefaultSeat() {
//   return SeatData(
//     id: '',
//     coachId: '',
//     seatNumber: '',
//     seatType: '',
//   );
// }
//
// @JsonSerializable()
// class PaymentData {
//   @JsonKey(name: 'id')
//   final String id;
//
//   @JsonKey(name: 'booking_id')
//   final String bookingId;
//
//   @JsonKey(name: 'amount')
//   final String amount;
//
//   @JsonKey(name: 'currency')
//   final String currency;
//
//   @JsonKey(name: 'payment_method')
//   final String paymentMethod;
//
//   @JsonKey(name: 'gateway_txn_id')
//   final String gatewayTxnId;
//
//   @JsonKey(name: 'status')
//   final String status;
//
//   @JsonKey(name: 'paid_at')
//   final String? paidAt;
//
//   PaymentData({
//     required this.id,
//     required this.bookingId,
//     required this.amount,
//     required this.currency,
//     required this.paymentMethod,
//     required this.gatewayTxnId,
//     required this.status,
//     this.paidAt,
//   });
//
//   factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
//     id: json['id'] ?? '',
//     bookingId: json['booking_id'] ?? '',
//     amount: json['amount'] ?? '0',
//     currency: json['currency'] ?? 'INR',
//     paymentMethod: json['payment_method'] ?? '',
//     gatewayTxnId: json['gateway_txn_id'] ?? '',
//     status: json['status'] ?? '',
//     paidAt: json['paid_at'],
//   );
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'booking_id': bookingId,
//     'amount': amount,
//     'currency': currency,
//     'payment_method': paymentMethod,
//     'gateway_txn_id': gatewayTxnId,
//     'status': status,
//     'paid_at': paidAt,
//   };
// }