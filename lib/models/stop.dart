import 'package:json_annotation/json_annotation.dart';
import 'package:quick_ticket/models/station_info.dart';

part 'stop.g.dart';

@JsonSerializable()
class Stop {
  final String id;
  final String trainId;
  final String stationId;
  final int stopOrder;
  final DateTime? arrivalTime;
  final DateTime? departureTime;
  final double distanceFromOriginKm;
  final StationInfo station;

  Stop({
    required this.id,
    required this.trainId,
    required this.stationId,
    required this.stopOrder,
    this.arrivalTime,
    this.departureTime,
    required this.distanceFromOriginKm,
    required this.station,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['id'],
      trainId: json['train_id'],
      stationId: json['station_id'],
      stopOrder: json['stop_order'],
      arrivalTime: json['arrival_time'] != null
          ? DateTime.parse(json['arrival_time'])
          : null,
      departureTime: json['departure_time'] != null
          ? DateTime.parse(json['departure_time'])
          : null,
      distanceFromOriginKm:
      (json['distance_from_origin_km'] as num).toDouble(),
      station: StationInfo.fromJson(json['station']),
    );
  }

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