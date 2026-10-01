import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_test/core/di/injection.dart';
import 'package:ws_test/presentation/session/path_session.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final solutions = getIt<PathSession>().solutions;

    return Scaffold(
      appBar: AppBar(title: const Text('Result list screen')),
      body: solutions.isEmpty
          ? const Center(child: Text('No results'))
          : ListView.separated(
              itemCount: solutions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final solution = solutions[index];
                return InkWell(
                  onTap: () => context.push('/preview/$index'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Text(
                      solution.path,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
