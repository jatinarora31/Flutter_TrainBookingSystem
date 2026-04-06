
import 'package:json_annotation/json_annotation.dart';

part 'fare.g.dart';

@JsonSerializable()
class FareOptions {
  final FareInfo? sleeper;
  final FareInfo? oneAc;
  final FareInfo? twoAc;

  FareOptions({this.sleeper, this.oneAc, this.twoAc});

  factory FareOptions.fromJson(Map<String, dynamic> json) {
    return FareOptions(
      sleeper:
      json['sleeper'] != null ? FareInfo.fromJson(json['sleeper']) : null,
      oneAc: json['1ac'] != null ? FareInfo.fromJson(json['1ac']) : null,
      twoAc: json['2ac'] != null ? FareInfo.fromJson(json['2ac']) : null,
    );
  }
  factory FareOptions.empty() {
    return FareOptions(
      oneAc: null,
      twoAc: null,
      sleeper: null,
    );
  }
}

@JsonSerializable()
class FareInfo {
  final double farePerSeat;
  final int distanceKm;

  FareInfo({required this.farePerSeat, required this.distanceKm});

  factory FareInfo.fromJson(Map<String, dynamic> json) {
    return FareInfo(
      farePerSeat: double.parse(json['fare_per_seat'].toString()),
      distanceKm: json['distance_km'],
    );
  }

  String get formatted => '₹${farePerSeat.toStringAsFixed(0)}';
}