enum Operator {
  add,
  subtract,
  multiply,
  divide,
}

class CalculatorState {
  final String currentInput;
  final String result;
  final Operator? operator;
  final String? error;

  CalculatorState({
    required this.currentInput,
    required this.result,
    this.operator,
    this.error,
  });
}