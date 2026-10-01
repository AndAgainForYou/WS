import 'package:go_router/go_router.dart';
import 'package:ws_test/presentation/screens/home/home_page.dart';
import 'package:ws_test/presentation/screens/preview/preview_page.dart';
import 'package:ws_test/presentation/screens/process/process_page.dart';
import 'package:ws_test/presentation/screens/results/results_page.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/process',
        builder: (context, state) => const ProcessPage(),
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) => const ResultsPage(),
      ),
      GoRoute(
        path: '/preview/:index',
        builder: (context, state) {
          final index = int.tryParse(state.pathParameters['index'] ?? '') ?? -1;
          return PreviewPage(index: index);
        },
      ),
    ],
  );
}
