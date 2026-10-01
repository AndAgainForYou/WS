import 'package:ws_test/core/error/app_result.dart';
import 'package:ws_test/domain/entities/path_solution.dart';
import 'package:ws_test/domain/repositories/path_task_repository.dart';

class SendResults {
  const SendResults(this._repository);

  final PathTaskRepository _repository;

  Future<AppResult<void>> call({
    required String url,
    required List<PathSolution> solutions,
  }) {
    return _repository.sendResults(url: url, solutions: solutions);
  }
}
