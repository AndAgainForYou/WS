import 'package:equatable/equatable.dart';

enum ProcessPhase {
  fetching,
  calculating,
  ready,
  sending,
  success,
  fetchError,
  sendError,
}

class ProcessState extends Equatable {
  const ProcessState({
    this.phase = ProcessPhase.fetching,
    this.percent = 0,
    this.message,
  });

  final ProcessPhase phase;
  final int percent;
  final String? message;

  bool get showSendButton =>
      phase == ProcessPhase.ready ||
      phase == ProcessPhase.sending ||
      phase == ProcessPhase.sendError ||
      phase == ProcessPhase.success;

  bool get isSending => phase == ProcessPhase.sending;

  bool get isBusy =>
      phase == ProcessPhase.fetching ||
      phase == ProcessPhase.calculating ||
      phase == ProcessPhase.sending;

  String get statusText {
    return switch (phase) {
      ProcessPhase.fetching => 'Fetching data from server...',
      ProcessPhase.calculating => 'Calculating...',
      ProcessPhase.ready ||
      ProcessPhase.sending ||
      ProcessPhase.success =>
        'All calculations has finished, you can send your results to server',
      ProcessPhase.fetchError => message ?? 'Failed to fetch data',
      ProcessPhase.sendError => message ?? 'Failed to send results',
    };
  }

  ProcessState copyWith({
    ProcessPhase? phase,
    int? percent,
    String? message,
    bool clearMessage = false,
  }) {
    return ProcessState(
      phase: phase ?? this.phase,
      percent: percent ?? this.percent,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [phase, percent, message];
}
