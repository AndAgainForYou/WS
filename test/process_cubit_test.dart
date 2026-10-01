import 'package:flutter_test/flutter_test.dart';
import 'package:ws_test/core/error/app_result.dart';
import 'package:ws_test/domain/entities/grid_point.dart';
import 'package:ws_test/domain/entities/path_solution.dart';
import 'package:ws_test/domain/entities/path_task.dart';
import 'package:ws_test/domain/repositories/path_task_repository.dart';
import 'package:ws_test/domain/repositories/settings_repository.dart';
import 'package:ws_test/domain/services/path_finder.dart';
import 'package:ws_test/domain/usecases/fetch_tasks.dart';
import 'package:ws_test/domain/usecases/get_saved_api_url.dart';
import 'package:ws_test/domain/usecases/send_results.dart';
import 'package:ws_test/domain/usecases/solve_tasks.dart';
import 'package:ws_test/presentation/screens/process/process_cubit.dart';
import 'package:ws_test/presentation/screens/process/process_state.dart';
import 'package:ws_test/presentation/session/path_session.dart';

class _FakeSettingsRepository implements SettingsRepository {
  @override
  String? getApiUrl() => 'https://example.test/flutter/api';

  @override
  Future<void> saveApiUrl(String url) async {}
}

class _FakePathTaskRepository implements PathTaskRepository {
  _FakePathTaskRepository({this.sendMessage});

  String? sendMessage;
  bool sendCalled = false;
  List<PathSolution>? sentSolutions;

  @override
  Future<AppResult<List<PathTask>>> fetchTasks(String url) async {
    return const AppSuccess([
      PathTask(
        id: 'task-1',
        field: ['.X.', '.X.', '...'],
        start: GridPoint(x: 1, y: 2),
        end: GridPoint(x: 2, y: 0),
      ),
    ]);
  }

  @override
  Future<AppResult<void>> sendResults({
    required String url,
    required List<PathSolution> solutions,
  }) async {
    sendCalled = true;
    sentSolutions = solutions;
    if (sendMessage != null) {
      return AppError(sendMessage!);
    }
    return const AppSuccess(null);
  }
}

void main() {
  test('start fetches tasks, calculates progress and prepares send', () async {
    final repository = _FakePathTaskRepository();
    final session = PathSession();
    final cubit = ProcessCubit(
      getSavedApiUrl: GetSavedApiUrl(_FakeSettingsRepository()),
      fetchTasks: FetchTasks(repository),
      solveTasks: SolveTasks(PathFinder()),
      sendResults: SendResults(repository),
      session: session,
    );

    await cubit.start();

    expect(cubit.state.phase, ProcessPhase.ready);
    expect(cubit.state.percent, 100);
    expect(session.solutions, hasLength(1));
    expect(session.solutions.first.path, '(1,2)->(2,1)->(2,0)');

    await cubit.send();

    expect(repository.sendCalled, isTrue);
    expect(cubit.state.phase, ProcessPhase.success);
    await cubit.close();
  });

  test('send failure keeps the button available with an error message', () async {
    final repository = _FakePathTaskRepository(sendMessage: 'Too Many Requests');
    final cubit = ProcessCubit(
      getSavedApiUrl: GetSavedApiUrl(_FakeSettingsRepository()),
      fetchTasks: FetchTasks(repository),
      solveTasks: SolveTasks(PathFinder()),
      sendResults: SendResults(repository),
      session: PathSession(),
    );

    await cubit.start();
    await cubit.send();

    expect(cubit.state.phase, ProcessPhase.sendError);
    expect(cubit.state.message, 'Too Many Requests');
    expect(cubit.state.showSendButton, isTrue);
    await cubit.close();
  });
}
