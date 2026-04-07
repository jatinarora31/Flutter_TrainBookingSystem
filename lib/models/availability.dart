import 'package:json_annotation/json_annotation.dart';

part 'availability.g.dart';

@JsonSerializable()
class Availability {
  @JsonKey(name: 'available_seats')
  final int availableSeats;
  @JsonKey(name: 'coach_type_availability')
  final CoachTypeAvailability coachTypeAvailability;

  Availability({
    required this.availableSeats,
    required this.coachTypeAvailability,
  });

  factory Availability.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityFromJson(json);
}

@JsonSerializable()
class CoachTypeAvailability {
  @JsonKey(name: '1ac')
  final CoachAvailability oneAc;
  final CoachAvailability sleeper;
  @JsonKey(name: '2ac')
  final CoachAvailability twoAc;

  CoachTypeAvailability({
    required this.oneAc,
    required this.sleeper,
    required this.twoAc,
  });

  factory CoachTypeAvailability.fromJson(Map<String, dynamic> json) =>
      _$CoachTypeAvailabilityFromJson(json);
}

@JsonSerializable()
class CoachAvailability {
  @JsonKey(name: 'total_active_seats')
  final int totalActiveSeats;
  @JsonKey(name: 'available_seats')
  final int availableSeats;

  CoachAvailability({
    required this.totalActiveSeats,
    required this.availableSeats,
  });

  factory CoachAvailability.fromJson(Map<String, dynamic> json) =>
      _$CoachAvailabilityFromJson(json);
}