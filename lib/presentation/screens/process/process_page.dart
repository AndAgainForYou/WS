import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_test/core/di/injection.dart';
import 'package:ws_test/core/theme/app_colors.dart';
import 'package:ws_test/presentation/screens/process/process_cubit.dart';
import 'package:ws_test/presentation/screens/process/process_state.dart';
import 'package:ws_test/presentation/widgets/bottom_action_button.dart';

class ProcessPage extends StatelessWidget {
  const ProcessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProcessCubit>()..start(),
      child: const _ProcessView(),
    );
  }
}

class _ProcessView extends StatelessWidget {
  const _ProcessView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProcessCubit, ProcessState>(
      listenWhen: (previous, current) =>
          previous.phase != current.phase &&
          current.phase == ProcessPhase.success,
      listener: (context, state) {
        context.push('/results');
      },
      builder: (context, state) {
        final isError =
            state.phase == ProcessPhase.fetchError ||
            state.phase == ProcessPhase.sendError;

        return Scaffold(
          appBar: AppBar(title: const Text('Process screen')),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.statusText,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: isError ? Colors.red : null,
                                ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(height: 1),
                          const SizedBox(height: 16),
                          Text(
                            '${state.percent}%',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: state.isBusy &&
                                      state.phase != ProcessPhase.calculating
                                  ? null
                                  : state.percent / 100,
                              strokeWidth: 3,
                              color: AppColors.appBar,
                              backgroundColor: const Color(0xFFBBDEFB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (state.phase == ProcessPhase.fetchError)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: BottomActionButton(
                      label: 'Try again',
                      onPressed: context.read<ProcessCubit>().start,
                    ),
                  )
                else if (state.showSendButton)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: BottomActionButton(
                      label: 'Send results to server',
                      isLoading: state.isSending,
                      onPressed: context.read<ProcessCubit>().send,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
