import 'package:json_annotation/json_annotation.dart';

part 'availability.g.dart';

@JsonSerializable()
class Availability {
  @JsonKey(name: 'available_seats')
  final int availableSeats;
  @JsonKey(name: 'coach_type_availability')
  final CoachTypeGroup coachTypeAvailability;

  Availability({
    required this.availableSeats,
    required this.coachTypeAvailability
  });

  factory Availability.fromJson(Map<String, dynamic> json) =>
      _$AvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$AvailabilityToJson(this);

}

@JsonSerializable(fieldRename: FieldRename.snake)
class CoachTypeGroup {
  final CoachTypeAvailability oneAc;
  final CoachTypeAvailability twoAc;
  final CoachTypeAvailability sleeper;

  CoachTypeGroup({
    required this.oneAc,
    required this.twoAc,
    required this.sleeper,
  });

  factory CoachTypeGroup.fromJson(Map<String, dynamic> json) =>
      _$CoachTypeGroupFromJson(json);

  Map<String, dynamic> toJson() => _$CoachTypeGroupToJson(this);
}

@JsonSerializable()
class CoachTypeAvailability {
  @JsonKey(name: 'total_active_seats')
  final int totalActiveSeats;

  @JsonKey(name: 'available_seats')
  final int availableSeats;

  CoachTypeAvailability({
    required this.totalActiveSeats,
    required this.availableSeats,
  });

  factory CoachTypeAvailability.fromJson(Map<String, dynamic> json) {
    return CoachTypeAvailability(
      totalActiveSeats: (json['total_active_seats'] as num?)?.toInt() ?? 0,
      availableSeats: (json['available_seats'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _$CoachTypeAvailabilityToJson(this);
}

