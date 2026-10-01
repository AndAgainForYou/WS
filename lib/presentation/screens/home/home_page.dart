import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_test/core/di/injection.dart';
import 'package:ws_test/presentation/screens/home/home_cubit.dart';
import 'package:ws_test/presentation/screens/home/home_state.dart';
import 'package:ws_test/presentation/widgets/bottom_action_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: context.read<HomeCubit>().state.url,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onStart() async {
    final submitted = await context.read<HomeCubit>().submit();
    if (!mounted || !submitted) {
      return;
    }
    context.push('/process');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) => previous.url != current.url,
      listener: (context, state) {
        if (_controller.text != state.url) {
          _controller.value = TextEditingValue(
            text: state.url,
            selection: TextSelection.collapsed(offset: state.url.length),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Home screen')),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set valid API base URL in order to continue',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          return TextField(
                            controller: _controller,
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            onChanged: context.read<HomeCubit>().onUrlChanged,
                            onSubmitted: (_) => _onStart(),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.compare_arrows),
                              errorText: state.urlError,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return BottomActionButton(
                      label: 'Start counting process',
                      isLoading: state.isSaving,
                      onPressed: _onStart,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
