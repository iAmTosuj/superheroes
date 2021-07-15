import 'package:flutter_test/flutter_test.dart';
import 'package:superheroes/blocs/main_bloc.dart';

Future<void> reachNeededState(
    final WidgetTester tester, final MainPageState state) async {
  final int steps = MainPageState.values.indexOf(state);
  print(steps);
  for (int i = 0; i < steps + 1; i++) {
    print(i);
    await tester.tap(find.text("NEXT STATE"));
    await tester.pump();
  }
}
