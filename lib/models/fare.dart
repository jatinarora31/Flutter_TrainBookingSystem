import 'package:json_annotation/json_annotation.dart';

part 'fare.g.dart';

@JsonSerializable()
class FareOptions {
  @JsonKey(name: '1ac')
  final FareDetail? oneAc;
  @JsonKey(name: '2ac')
  final FareDetail? twoAc;
  final FareDetail? sleeper;

  FareOptions({
    this.oneAc,
    this.twoAc,
    this.sleeper,
  });

  factory FareOptions.fromJson(Map<String, dynamic> json) =>
      _$FareOptionsFromJson(json);
}

@JsonSerializable()
class FareDetail {
  @JsonKey(name: 'fare_per_seat')
  final String farePerSeat;

  FareDetail({
    required this.farePerSeat,
  });

  factory FareDetail.fromJson(Map<String, dynamic> json) =>
      _$FareDetailFromJson(json);
}