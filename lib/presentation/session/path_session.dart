import 'package:ws_test/domain/entities/path_solution.dart';

class PathSession {
  List<PathSolution> _solutions = const [];

  List<PathSolution> get solutions => _solutions;

  void replace(List<PathSolution> solutions) {
    _solutions = List.unmodifiable(solutions);
  }
}
