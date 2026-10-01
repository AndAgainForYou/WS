import 'package:equatable/equatable.dart';
import 'package:ws_test/domain/entities/grid_point.dart';

class PathTask extends Equatable {
  const PathTask({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  final String id;
  final List<String> field;
  final GridPoint start;
  final GridPoint end;

  @override
  List<Object?> get props => [id, field, start, end];
}
