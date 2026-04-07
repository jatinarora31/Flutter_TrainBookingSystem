import 'package:json_annotation/json_annotation.dart';
import 'package:quick_ticket/models/station_info.dart';

part 'stop.g.dart';

@JsonSerializable()
class Stop {
  final String id;
  @JsonKey(name: 'stop_order')
  final int stopOrder;
  @JsonKey(name: 'arrival_time')
  final DateTime? arrivalTime;
  @JsonKey(name: 'departure_time')
  final DateTime? departureTime;
  @JsonKey(name: 'distance_from_origin_km')
  final double distanceFromOriginKm;
  final StationInfo station;

  Stop({
    required this.id,
    required this.stopOrder,
    this.arrivalTime,
    this.departureTime,
    required this.distanceFromOriginKm,
    required this.station,
  });

  factory Stop.fromJson(Map<String, dynamic> json) =>
      _$StopFromJson(json);

  String get formattedArrival {
    if (arrivalTime == null) return '--:--';
    final h = arrivalTime!.hour.toString().padLeft(2, '0');
    final m = arrivalTime!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get formattedDeparture {
    if (departureTime == null) return '--:--';
    final h = departureTime!.hour.toString().padLeft(2, '0');
    final m = departureTime!.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}