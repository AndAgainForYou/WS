import 'package:flutter/material.dart';
import 'package:ws_test/core/di/injection.dart';
import 'package:ws_test/presentation/screens/preview/widgets/path_grid.dart';
import 'package:ws_test/presentation/session/path_session.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final solutions = getIt<PathSession>().solutions;
    if (index < 0 || index >= solutions.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Preview screen')),
        body: const Center(child: Text('Result not found')),
      );
    }

    final solution = solutions[index];

    return Scaffold(
      appBar: AppBar(title: const Text('Preview screen')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              PathGrid(solution: solution),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  solution.path,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
