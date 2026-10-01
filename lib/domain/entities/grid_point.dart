import 'package:equatable/equatable.dart';

class GridPoint extends Equatable {
  const GridPoint({required this.x, required this.y});

  final int x;
  final int y;

  String get display => '($x,$y)';

  @override
  List<Object?> get props => [x, y];
}
