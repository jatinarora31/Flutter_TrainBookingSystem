import 'package:json_annotation/json_annotation.dart';

part 'seat_map.g.dart';

@JsonSerializable()
class SeatMap {
  @JsonKey(name: 'requested_segment')
  final RequestedSegment requestedSegment;
  @JsonKey(name: 'unavailable_seat_ids')
  final List<String> unavailableSeatIds;
  final List<dynamic> allocations;

  SeatMap({
    required this.requestedSegment,
    required this.unavailableSeatIds,
    required this.allocations,
  });

  factory SeatMap.fromJson(Map<String, dynamic> json) =>
      _$SeatMapFromJson(json);
}

@JsonSerializable()
class RequestedSegment {
  @JsonKey(name: 'src_station_id')
  final String srcStationId;
  @JsonKey(name: 'dst_station_id')
  final String dstStationId;
  @JsonKey(name: 'src_stop_order')
  final int srcStopOrder;
  @JsonKey(name: 'dst_stop_order')
  final int dstStopOrder;

  RequestedSegment({
    required this.srcStationId,
    required this.dstStationId,
    required this.srcStopOrder,
    required this.dstStopOrder,
  });

  factory RequestedSegment.fromJson(Map<String, dynamic> json) =>
      _$RequestedSegmentFromJson(json);
}