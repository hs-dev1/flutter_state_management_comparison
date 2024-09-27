import '../models/calculator_state.dart';

String operatorToString(Operator op) {
  switch (op) {
    case Operator.add:
      return '+';
    case Operator.subtract:
      return '-';
    case Operator.multiply:
      return '*';
    case Operator.divide:
      return '/';
    default:
      return '';
  }
}
