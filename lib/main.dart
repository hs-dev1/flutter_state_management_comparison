import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_example/models/calculator_state.dart';

import 'reducers/calculator_reducer.dart';
import 'ui/calculator_page.dart';

void main() {
  final store = Store<CalculatorState>(
    calculatorReducer,
    initialState: CalculatorState(currentInput: '0', result: '0', operator: null),
  );
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<CalculatorState> store;
  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<CalculatorState>(
      store: store,
      child: const MaterialApp(
        home: CalculatorPage(),
      ),
    );
  }
}
