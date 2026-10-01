import 'package:equatable/equatable.dart';
import 'package:ws_test/domain/entities/grid_point.dart';

class PathSolution extends Equatable {
  const PathSolution({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
    required this.steps,
    required this.path,
  });

  final String id;
  final List<String> field;
  final GridPoint start;
  final GridPoint end;
  final List<GridPoint> steps;
  final String path;

  @override
  List<Object?> get props => [id, field, start, end, steps, path];
}
