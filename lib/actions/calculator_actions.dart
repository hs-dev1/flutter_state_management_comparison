import '../models/calculator_state.dart';

class NumberAction {
  final String number;
  NumberAction(this.number);
}

class OperatorAction {
  final Operator operator;
  OperatorAction(this.operator);
}

class CalculateAction {}

class ClearAction {}
