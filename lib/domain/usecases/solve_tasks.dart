import 'package:ws_test/domain/entities/grid.dart';
import 'package:ws_test/domain/entities/path_solution.dart';
import 'package:ws_test/domain/entities/path_task.dart';
import 'package:ws_test/domain/services/path_finder.dart';

class SolveTasks {
  const SolveTasks(this._pathFinder);

  final PathFinder _pathFinder;

  PathSolution solveOne(PathTask task) {
    final steps = _pathFinder.findShortestPath(
      grid: Grid(field: task.field),
      start: task.start,
      end: task.end,
    );

    return PathSolution(
      id: task.id,
      field: task.field,
      start: task.start,
      end: task.end,
      steps: steps,
      path: PathFinder.formatPath(steps),
    );
  }
}
