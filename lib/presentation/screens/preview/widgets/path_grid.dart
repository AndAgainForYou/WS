import 'package:flutter/material.dart';
import 'package:ws_test/core/theme/app_colors.dart';
import 'package:ws_test/domain/entities/grid.dart';
import 'package:ws_test/domain/entities/grid_point.dart';
import 'package:ws_test/domain/entities/path_solution.dart';

enum CellType { empty, blocked, start, end, path }

class PathGrid extends StatelessWidget {
  const PathGrid({super.key, required this.solution});

  final PathSolution solution;

  @override
  Widget build(BuildContext context) {
    final grid = Grid(field: solution.field);
    final size = grid.size;
    if (size == 0) {
      return const SizedBox.shrink();
    }

    final pathCells = solution.steps.toSet();

    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black87),
        ),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size,
          ),
          itemCount: size * size,
          itemBuilder: (context, index) {
            final x = index % size;
            final y = index ~/ size;
            final point = GridPoint(x: x, y: y);
            final type = _cellType(point, grid, pathCells);
            return _GridCell(point: point, type: type);
          },
        ),
      ),
    );
  }

  CellType _cellType(
    GridPoint point,
    Grid grid,
    Set<GridPoint> pathCells,
  ) {
    if (grid.isBlocked(point)) {
      return CellType.blocked;
    }
    if (point == solution.start) {
      return CellType.start;
    }
    if (point == solution.end) {
      return CellType.end;
    }
    if (pathCells.contains(point)) {
      return CellType.path;
    }
    return CellType.empty;
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({required this.point, required this.type});

  final GridPoint point;
  final CellType type;

  @override
  Widget build(BuildContext context) {
    final background = switch (type) {
      CellType.start => AppColors.startCell,
      CellType.end => AppColors.endCell,
      CellType.blocked => AppColors.blockedCell,
      CellType.path => AppColors.pathCell,
      CellType.empty => AppColors.emptyCell,
    };
    final foreground = type == CellType.blocked ? Colors.white : Colors.black87;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: Colors.black54, width: 0.5),
      ),
      child: Center(
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              point.display,
              style: TextStyle(
                color: foreground,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
