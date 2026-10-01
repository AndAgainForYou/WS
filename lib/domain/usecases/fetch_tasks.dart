import 'package:ws_test/core/error/app_result.dart';
import 'package:ws_test/domain/entities/path_task.dart';
import 'package:ws_test/domain/repositories/path_task_repository.dart';

class FetchTasks {
  const FetchTasks(this._repository);

  final PathTaskRepository _repository;

  Future<AppResult<List<PathTask>>> call(String url) {
    return _repository.fetchTasks(url);
  }
}
