import 'package:ws_test/core/utils/json_utils.dart';
import 'package:ws_test/domain/entities/grid_point.dart';

class GridPointDto {
  const GridPointDto({required this.x, required this.y});

  final int x;
  final int y;

  factory GridPointDto.fromJson(Map<String, dynamic> json) {
    return GridPointDto(
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y};

  GridPoint toEntity() => GridPoint(x: x, y: y);

  static GridPointDto fromDynamic(dynamic json) {
    return GridPointDto.fromJson(asJsonMap(json));
  }
}
