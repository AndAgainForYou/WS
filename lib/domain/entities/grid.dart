import 'package:ws_test/domain/entities/grid_point.dart';

class Grid {
  const Grid({required this.field});

  final List<String> field;

  int get size => field.length;

  bool inBounds(GridPoint point) {
    return point.y >= 0 &&
        point.y < field.length &&
        point.x >= 0 &&
        point.x < field[point.y].length;
  }

  bool isBlocked(GridPoint point) {
    return inBounds(point) && field[point.y][point.x] == 'X';
  }

  bool isWalkable(GridPoint point) {
    return inBounds(point) && field[point.y][point.x] != 'X';
  }

  Iterable<GridPoint> neighbors(GridPoint point) sync* {
    const deltas = [
      GridPoint(x: -1, y: -1),
      GridPoint(x: 0, y: -1),
      GridPoint(x: 1, y: -1),
      GridPoint(x: -1, y: 0),
      GridPoint(x: 1, y: 0),
      GridPoint(x: -1, y: 1),
      GridPoint(x: 0, y: 1),
      GridPoint(x: 1, y: 1),
    ];

    for (final delta in deltas) {
      final next = GridPoint(x: point.x + delta.x, y: point.y + delta.y);
      if (isWalkable(next)) {
        yield next;
      }
    }
  }
}
