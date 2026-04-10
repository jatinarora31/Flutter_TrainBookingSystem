import 'package:QuickTicket/models/seat.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coach.g.dart';

@JsonSerializable()
class Coach {
  final String id;
  @JsonKey(name: 'train_id')
  final String trainId;
  @JsonKey(name: 'coach_number')
  final String coachNumber;
  @JsonKey(name: 'coach_type')
  final String coachType;
  @JsonKey(name: 'total_seats')
  final int totalSeats;
  final List<Seat> seats;

  Coach({
    required this.id,
    required this.trainId,
    required this.coachNumber,
    required this.coachType,
    required this.totalSeats,
    required this.seats,
  });

  factory Coach.fromJson(Map<String, dynamic> json) =>
      _$CoachFromJson(json);

  String get displayType {
    switch (coachType) {
      case '1ac':
        return 'First AC';
      case '2ac':
        return 'Second AC';
      case 'sleeper':
        return 'Sleeper';
      default:
        return coachType;
    }
  }
}