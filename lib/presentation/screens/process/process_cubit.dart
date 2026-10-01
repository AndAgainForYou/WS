import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ws_test/core/constants/app_constants.dart';
import 'package:ws_test/core/error/app_result.dart';
import 'package:ws_test/domain/entities/path_solution.dart';
import 'package:ws_test/domain/entities/path_task.dart';
import 'package:ws_test/domain/usecases/fetch_tasks.dart';
import 'package:ws_test/domain/usecases/get_saved_api_url.dart';
import 'package:ws_test/domain/usecases/send_results.dart';
import 'package:ws_test/domain/usecases/solve_tasks.dart';
import 'package:ws_test/presentation/screens/process/process_state.dart';
import 'package:ws_test/presentation/session/path_session.dart';

class ProcessCubit extends Cubit<ProcessState> {
  ProcessCubit({
    required GetSavedApiUrl getSavedApiUrl,
    required FetchTasks fetchTasks,
    required SolveTasks solveTasks,
    required SendResults sendResults,
    required PathSession session,
  }) : _getSavedApiUrl = getSavedApiUrl,
       _fetchTasks = fetchTasks,
       _solveTasks = solveTasks,
       _sendResults = sendResults,
       _session = session,
       super(const ProcessState());

  final GetSavedApiUrl _getSavedApiUrl;
  final FetchTasks _fetchTasks;
  final SolveTasks _solveTasks;
  final SendResults _sendResults;
  final PathSession _session;

  String get _url => _getSavedApiUrl() ?? AppConstants.defaultApiUrl;

  Future<void> start() async {
    emit(const ProcessState(phase: ProcessPhase.fetching, percent: 0));

    final result = await _fetchTasks(_url);
    if (isClosed) {
      return;
    }

    switch (result) {
      case AppError<List<PathTask>>(:final message):
        emit(
          ProcessState(
            phase: ProcessPhase.fetchError,
            percent: 0,
            message: message,
          ),
        );
      case AppSuccess<List<PathTask>>(:final data):
        await _calculate(data);
    }
  }

  Future<void> _calculate(List<PathTask> tasks) async {
    if (tasks.isEmpty) {
      _session.replace(const []);
      emit(const ProcessState(phase: ProcessPhase.ready, percent: 100));
      return;
    }

    emit(const ProcessState(phase: ProcessPhase.calculating, percent: 0));
    final solutions = <PathSolution>[];

    for (var i = 0; i < tasks.length; i++) {
      solutions.add(_solveTasks.solveOne(tasks[i]));
      if (isClosed) {
        return;
      }
      final percent = ((i + 1) / tasks.length * 100).round();
      emit(ProcessState(phase: ProcessPhase.calculating, percent: percent));
      await Future<void>.delayed(Duration.zero);
    }

    _session.replace(solutions);
    emit(const ProcessState(phase: ProcessPhase.ready, percent: 100));
  }

  Future<void> send() async {
    if (state.isSending) {
      return;
    }

    emit(
      state.copyWith(
        phase: ProcessPhase.sending,
        percent: 100,
        clearMessage: true,
      ),
    );

    final result = await _sendResults(
      url: _url,
      solutions: _session.solutions,
    );
    if (isClosed) {
      return;
    }

    switch (result) {
      case AppError<void>(:final message):
        emit(
          state.copyWith(phase: ProcessPhase.sendError, message: message),
        );
      case AppSuccess<void>():
        emit(state.copyWith(phase: ProcessPhase.success));
    }
  }
}
