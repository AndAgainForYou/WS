import 'dart:collection';

import 'package:ws_test/domain/entities/grid.dart';
import 'package:ws_test/domain/entities/grid_point.dart';

class PathFinder {
  List<GridPoint> findShortestPath({
    required Grid grid,
    required GridPoint start,
    required GridPoint end,
  }) {
    if (!grid.isWalkable(start) || !grid.isWalkable(end)) {
      return const [];
    }
    if (start == end) {
      return [start];
    }

    final visited = <GridPoint>{start};
    final parent = <GridPoint, GridPoint>{};
    final queue = Queue<GridPoint>()..add(start);

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (current == end) {
        return _reconstruct(parent: parent, start: start, end: end);
      }

      for (final next in grid.neighbors(current)) {
        if (visited.add(next)) {
          parent[next] = current;
          queue.add(next);
        }
      }
    }

    return const [];
  }

  static String formatPath(List<GridPoint> steps) {
    return steps.map((point) => point.display).join('->');
  }

  List<GridPoint> _reconstruct({
    required Map<GridPoint, GridPoint> parent,
    required GridPoint start,
    required GridPoint end,
  }) {
    final path = <GridPoint>[end];
    var current = end;
    while (current != start) {
      current = parent[current]!;
      path.add(current);
    }
    return path.reversed.toList();
  }
}
