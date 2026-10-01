import 'package:ws_test/core/utils/json_utils.dart';
import 'package:ws_test/data/models/grid_point_dto.dart';
import 'package:ws_test/domain/entities/path_task.dart';

class PathTaskDto {
  const PathTaskDto({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  final String id;
  final List<String> field;
  final GridPointDto start;
  final GridPointDto end;

  factory PathTaskDto.fromJson(Map<String, dynamic> json) {
    return PathTaskDto(
      id: json['id'] as String,
      field: (json['field'] as List<dynamic>).map((e) => e as String).toList(),
      start: GridPointDto.fromDynamic(json['start']),
      end: GridPointDto.fromDynamic(json['end']),
    );
  }

  static PathTaskDto fromDynamic(dynamic json) {
    return PathTaskDto.fromJson(asJsonMap(json));
  }

  PathTask toEntity() {
    return PathTask(
      id: id,
      field: field,
      start: start.toEntity(),
      end: end.toEntity(),
    );
  }
}
