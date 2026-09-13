import 'package:flutter_test/flutter_test.dart';

import 'package:laboratorio_1/main.dart';

void main() {
  testWidgets('El contador de presentes arranca en 0', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AttendanceApp());

    expect(find.text('Presentes: 0 / 12'), findsOneWidget);
  });
}