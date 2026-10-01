import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ws_test/domain/entities/grid_point.dart';
import 'package:ws_test/domain/entities/path_solution.dart';
import 'package:ws_test/domain/usecases/validate_api_url.dart';
import 'package:ws_test/presentation/screens/preview/widgets/path_grid.dart';

void main() {
  testWidgets('PathGrid shows coordinates and the path under the cells', (
    tester,
  ) async {
    const solution = PathSolution(
      id: 'test',
      field: [
        '.X.',
        '.X.',
        '...',
      ],
      start: GridPoint(x: 1, y: 2),
      end: GridPoint(x: 2, y: 0),
      steps: [
        GridPoint(x: 1, y: 2),
        GridPoint(x: 2, y: 1),
        GridPoint(x: 2, y: 0),
      ],
      path: '(1,2)->(2,1)->(2,0)',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PathGrid(solution: solution),
        ),
      ),
    );

    expect(find.text('(1,2)'), findsOneWidget);
    expect(find.text('(2,0)'), findsOneWidget);
    expect(find.text('(0,0)'), findsOneWidget);
  });

  test('ValidateApiUrl accepts http(s) URLs with query parameters', () {
    const validate = ValidateApiUrl();

    expect(validate('https://flutter.webspark.dev/flutter/api'), isNull);
    expect(
      validate('https://flutter.webspark.dev/flutter/api?debug=1'),
      isNull,
    );
    expect(validate(''), 'URL cannot be empty');
    expect(validate('not-a-url'), 'Please enter a valid URL');
    expect(validate('ftp://example.com'), 'URL must start with http:// or https://');
  });
}
