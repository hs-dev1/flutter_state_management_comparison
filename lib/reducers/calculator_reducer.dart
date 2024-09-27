import 'package:decimal/decimal.dart';
import '../models/calculator_state.dart';
import '../actions/calculator_actions.dart';

CalculatorState calculatorReducer(CalculatorState state, dynamic action) {
  if (action is NumberAction) {
    final newInput = (state.currentInput == '0' && action.number != '.') ? action.number : state.currentInput + action.number;

    // Prevent multiple decimal points
    if (action.number == '.' && state.currentInput.contains('.')) {
      return state;
    }

    return CalculatorState(
      currentInput: newInput,
      result: state.operator == null ? newInput : state.result,
      operator: state.operator,
      error: null,
    );
  } else if (action is OperatorAction) {
    // If there's a pending operation, calculate it first
    final newResult = state.operator != null ? _calculateResult(state.result, state.currentInput, state.operator) : state.currentInput;

    return CalculatorState(
      currentInput: '0',
      result: newResult,
      operator: action.operator,
      error: null,
    );
  } else if (action is CalculateAction) {
    final result = _calculateResult(state.result, state.currentInput, state.operator);
    return CalculatorState(
      currentInput: result,
      result: result,
      operator: null,
      error: null,
    );
  } else if (action is ClearAction) {
    return CalculatorState(currentInput: '0', result: '0', operator: null, error: null);
  }
  return state;
}

String _calculateResult(String input1, String input2, Operator? operator) {
  try {
    final num1 = Decimal.parse(input1);
    final num2 = Decimal.parse(input2);
    Decimal result;

    switch (operator) {
      case Operator.add:
        result = num1 + num2;
        break;
      case Operator.subtract:
        result = num1 - num2;
        break;
      case Operator.multiply:
        result = num1 * num2;
        break;
      case Operator.divide:
        if (num2 == Decimal.zero) {
          throw Exception('Division by zero');
        }
        result = (num1 / num2).toDecimal();
        break;
      default:
        return input2;
    }

    return result.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  } catch (e) {
    return 'Error';
  }
}
