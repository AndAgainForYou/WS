import 'package:flutter_test/flutter_test.dart';
import 'package:ws_test/domain/entities/grid.dart';
import 'package:ws_test/domain/entities/grid_point.dart';
import 'package:ws_test/domain/services/path_finder.dart';

void main() {
  late PathFinder pathFinder;

  setUp(() {
    pathFinder = PathFinder();
  });

  test('finds the shortest 8-direction path from the assignment example', () {
    const grid = Grid(
      field: [
        '.X.',
        '.X.',
        '...',
      ],
    );

    final path = pathFinder.findShortestPath(
      grid: grid,
      start: const GridPoint(x: 1, y: 2),
      end: const GridPoint(x: 2, y: 0),
    );

    expect(PathFinder.formatPath(path), '(1,2)->(2,1)->(2,0)');
  });

  test('finds a diagonal path across a blocked 4x4 maze', () {
    const grid = Grid(
      field: [
        'XXX.',
        'X..X',
        'X..X',
        '.XXX',
      ],
    );

    final path = pathFinder.findShortestPath(
      grid: grid,
      start: const GridPoint(x: 0, y: 3),
      end: const GridPoint(x: 3, y: 0),
    );

    expect(PathFinder.formatPath(path), '(0,3)->(1,2)->(2,1)->(3,0)');
  });

  test('returns a single point when start equals end', () {
    const grid = Grid(field: ['..', '..']);
    const point = GridPoint(x: 0, y: 0);

    final path = pathFinder.findShortestPath(
      grid: grid,
      start: point,
      end: point,
    );

    expect(path, [point]);
  });

  test('returns an empty path when the destination is unreachable', () {
    const grid = Grid(
      field: [
        '.X.',
        'XXX',
        '...',
      ],
    );

    final path = pathFinder.findShortestPath(
      grid: grid,
      start: const GridPoint(x: 0, y: 0),
      end: const GridPoint(x: 1, y: 2),
    );

    expect(path, isEmpty);
  });
}
