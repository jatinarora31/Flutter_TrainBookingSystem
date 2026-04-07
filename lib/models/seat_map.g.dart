// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_map.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeatMap _$SeatMapFromJson(Map<String, dynamic> json) => SeatMap(
  requestedSegment: RequestedSegment.fromJson(
    json['requested_segment'] as Map<String, dynamic>,
  ),
  unavailableSeatIds: (json['unavailable_seat_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  allocations: json['allocations'] as List<dynamic>,
);

Map<String, dynamic> _$SeatMapToJson(SeatMap instance) => <String, dynamic>{
  'requested_segment': instance.requestedSegment,
  'unavailable_seat_ids': instance.unavailableSeatIds,
  'allocations': instance.allocations,
};

RequestedSegment _$RequestedSegmentFromJson(Map<String, dynamic> json) =>
    RequestedSegment(
      srcStationId: json['src_station_id'] as String,
      dstStationId: json['dst_station_id'] as String,
      srcStopOrder: (json['src_stop_order'] as num).toInt(),
      dstStopOrder: (json['dst_stop_order'] as num).toInt(),
    );

Map<String, dynamic> _$RequestedSegmentToJson(RequestedSegment instance) =>
    <String, dynamic>{
      'src_station_id': instance.srcStationId,
      'dst_station_id': instance.dstStationId,
      'src_stop_order': instance.srcStopOrder,
      'dst_stop_order': instance.dstStopOrder,
    };
