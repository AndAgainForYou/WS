import 'package:ws_test/core/error/app_result.dart';
import 'package:ws_test/core/error/exceptions.dart';
import 'package:ws_test/data/datasources/remote/path_task_remote_ds.dart';
import 'package:ws_test/domain/entities/path_solution.dart';
import 'package:ws_test/domain/entities/path_task.dart';
import 'package:ws_test/domain/repositories/path_task_repository.dart';

class PathTaskRepositoryImpl implements PathTaskRepository {
  const PathTaskRepositoryImpl(this._remoteDataSource);

  final PathTaskRemoteDataSource _remoteDataSource;

  @override
  Future<AppResult<List<PathTask>>> fetchTasks(String url) async {
    try {
      final dtos = await _remoteDataSource.fetchTasks(url);
      return AppSuccess(dtos.map((dto) => dto.toEntity()).toList());
    } on ServerException catch (error) {
      return AppError(error.message);
    } on Exception catch (error) {
      return AppError(error.toString());
    }
  }

  @override
  Future<AppResult<void>> sendResults({
    required String url,
    required List<PathSolution> solutions,
  }) async {
    try {
      await _remoteDataSource.sendResults(
        url: url,
        payload: solutions.map(_toPayload).toList(),
      );
      return const AppSuccess(null);
    } on ServerException catch (error) {
      return AppError(error.message);
    } on Exception catch (error) {
      return AppError(error.toString());
    }
  }

  Map<String, dynamic> _toPayload(PathSolution solution) {
    return {
      'id': solution.id,
      'result': {
        'steps': [
          for (final step in solution.steps) {'x': step.x, 'y': step.y},
        ],
        'path': solution.path,
      },
    };
  }
}
