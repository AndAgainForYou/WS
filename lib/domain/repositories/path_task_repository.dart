import 'package:ws_test/core/error/app_result.dart';
import 'package:ws_test/domain/entities/path_solution.dart';
import 'package:ws_test/domain/entities/path_task.dart';

abstract class PathTaskRepository {
  Future<AppResult<List<PathTask>>> fetchTasks(String url);

  Future<AppResult<void>> sendResults({
    required String url,
    required List<PathSolution> solutions,
  });
}
