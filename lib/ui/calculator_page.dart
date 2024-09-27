import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../models/calculator_state.dart';
import '../actions/calculator_actions.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redux Calculator"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Display current input (expression)
          StoreConnector<CalculatorState, String>(
            converter: (store) => store.state.currentInput,
            builder: (context, currentInput) {
              return Container(
                padding: const EdgeInsets.all(24.0),
                alignment: Alignment.centerRight,
                child: Text(
                  currentInput,
                  style: const TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          // Display result (calculated result)
          StoreConnector<CalculatorState, String>(
            converter: (store) => store.state.result,
            builder: (context, result) {
              return Container(
                padding: const EdgeInsets.all(24.0),
                alignment: Alignment.centerRight,
                child: Text(
                  "= $result",
                  style: const TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              );
            },
          ),
          const Divider(),
          // Number Pad and Operators
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildRow(context, ['7', '8', '9', '/']),
                _buildRow(context, ['4', '5', '6', '*']),
                _buildRow(context, ['1', '2', '3', '-']),
                _buildRow(context, ['0', '.', '=', '+']),
              ],
            ),
          ),
          // Clear Button
          StoreConnector<CalculatorState, VoidCallback>(
            converter: (store) {
              return () => store.dispatch(ClearAction());
            },
            builder: (context, clearCallback) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: clearCallback,
                  child: const Text('Clear', style: TextStyle(fontSize: 24)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((text) {
          return _buildButton(context, text);
        }).toList(),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    return Expanded(
      child: StoreConnector<CalculatorState, VoidCallback>(
        converter: (store) {
          return () {
            if (text == '=') {
              store.dispatch(CalculateAction());
            } else if (text == '+') {
              store.dispatch(OperatorAction(Operator.add));
            } else if (text == '-') {
              store.dispatch(OperatorAction(Operator.subtract));
            } else if (text == '*') {
              store.dispatch(OperatorAction(Operator.multiply));
            } else if (text == '/') {
              store.dispatch(OperatorAction(Operator.divide));
            } else {
              store.dispatch(NumberAction(text));
            }
          };
        },
        builder: (context, callback) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: callback,
              child: Text(text, style: const TextStyle(fontSize: 24)),
            ),
          );
        },
      ),
    );
  }
}
