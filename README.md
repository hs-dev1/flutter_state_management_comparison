
### README for Redux-based Calculator App (Level 3)

---

### Overview

This project demonstrates a simple **Redux-based calculator** using Flutter. We progressively added complexity, building on the foundational skills established in Level 2. This calculator allows users to perform basic arithmetic operations: addition, subtraction, multiplication, and division.

---

### Concepts Covered

1. **Redux State Management**: We use Redux to manage the state of the calculator, which ensures the app's state is predictable and manageable.
2. **State Mutability**: By using `Store` from Redux, our app can respond to dispatched actions like number inputs, operators, and clearing the calculator.
3. **State Splitting**: The `CalculatorState` class keeps track of both the current input and the final result, which helps separate the display of the expression from the calculated value.
4. **Decimal Handling**: We've integrated the `decimal` package to handle decimal operations precisely, avoiding typical floating-point issues.

---

### Folder Structure

We split the code into several files to maintain clarity:

- **actions**: Holds action classes for number input, operator input, calculating the result, and clearing the calculator.
- **models**: Holds the state model (`CalculatorState`) and the enumeration for operators (`Operator`).
- **reducers**: Contains the core logic of Redux, handling how the state should change based on dispatched actions.
- **ui**: Contains the `CalculatorPage` widget, which handles the UI rendering and interaction.

---

### Code Breakdown

#### 1. **Main Class (`main.dart`)**

The main entry point of the application. We initialize the Redux store with the `calculatorReducer` and the initial state. The app is wrapped with `StoreProvider` to provide global state access.

```dart
void main() {
  final store = Store<CalculatorState>(
    calculatorReducer,
    initialState: CalculatorState(currentInput: '0', result: '0', operator: null),
  );
  runApp(MyApp(store: store));
}
```

#### 2. **Calculator State (`calculator_state.dart`)**

This defines the structure of our app's state, which keeps track of the current input, the result, and the operator. 

```dart
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
```

We also define an `Operator` enum to handle the four arithmetic operations.

```dart
enum Operator {
  add,
  subtract,
  multiply,
  divide,
}
```

#### 3. **Actions (`calculator_actions.dart`)**

Actions define what can happen in the app. For example, `NumberAction` is dispatched when a number button is pressed.

```dart
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
```

#### 4. **Reducer (`calculator_reducer.dart`)**

The reducer defines how the state changes in response to actions. For instance, when a number is pressed, we update the current input.

```dart
import  'package:decimal/decimal.dart';
import  '../models/calculator_state.dart';
import  '../actions/calculator_actions.dart';
CalculatorState  calculatorReducer(CalculatorState  state, dynamic  action) {
if (action  is  NumberAction) {
final  newInput  = (state.currentInput  ==  '0'  &&  action.number  !=  '.') ?  action.number  :  state.currentInput  +  action.number;
// Prevent multiple decimal points
if (action.number  ==  '.'  &&  state.currentInput.contains('.')) {
return  state;
}
return  CalculatorState(
currentInput:  newInput,
result:  state.operator  ==  null  ?  newInput  :  state.result,
operator:  state.operator,
error:  null,
);} else  if (action  is  OperatorAction) {
// If there's a pending operation, calculate it first
final  newResult  =  state.operator  !=  null  ?  _calculateResult(state.result, state.currentInput, state.operator) :  state.currentInput;
return  CalculatorState(
currentInput:  '0',
result:  newResult,
operator:  action.operator,
error:  null,
);
} else  if (action  is  CalculateAction) {
final  result  =  _calculateResult(state.result, state.currentInput, state.operator);
return  CalculatorState(
currentInput:  result,
result:  result,
operator:  null,
error:  null,
);
} else  if (action  is  ClearAction) {
return  CalculatorState(currentInput:  '0', result:  '0', operator:  null, error:  null);
}
return  state;
}
String  _calculateResult(String  input1, String  input2, Operator?  operator) {
try {
final  num1  =  Decimal.parse(input1);
final  num2  =  Decimal.parse(input2);
Decimal  result;  
switch (operator) {
case  Operator.add:
result  =  num1  +  num2;
break;
case  Operator.subtract:
result  =  num1  -  num2;
break;
case  Operator.multiply:
result  =  num1  *  num2;
break;
case  Operator.divide:
if (num2  ==  Decimal.zero) {
throw  Exception('Division by zero');
}
result  = (num1  /  num2).toDecimal();
break;
default:
return  input2;
}
return  result.toStringAsFixed(8).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
} catch (e) {
return  'Error';
}}
```

The `calculatorReducer` handles four main actions: number inputs, operator selection, calculation, and clearing the calculator.

#### 5. **UI (`calculator_page.dart`)**

The UI is built using Flutter's `StoreConnector` to connect the UI to the Redux store. We display both the current input and the result.

- **Current Input Display**: Shows the expression being typed (e.g., "7 + 6").
- **Result Display**: Shows the calculated result (e.g., "= 13").

```dart
StoreConnector<CalculatorState, String>(
  converter: (store) => store.state.currentInput,
  builder: (context, currentInput) {
    return Text(
      currentInput,
      style: TextStyle(fontSize: 36.0),
    );
  },
);
```

#### Number Pad and Operator Buttons

The number and operator buttons dispatch actions based on user input.

```dart
Widget _buildButton(BuildContext context, String text) {
  return StoreConnector<CalculatorState, VoidCallback>(
    converter: (store) {
      return () {
        if (text == '=') {
          store.dispatch(CalculateAction());
        } else if (text == '+') {
          store.dispatch(OperatorAction(Operator.add));
        } 
        // Handle other buttons...
      };
    },
    builder: (context, callback) {
      return ElevatedButton(
        onPressed: callback,
        child: Text(text, style: TextStyle(fontSize: 24)),
      );
    },
  );
}
```

---

### Usage

1. **Clone the Repository**: Download or clone this project to your local machine.
2. **Install Dependencies**: Run `flutter pub get` to install all dependencies.
3. **Run the App**: Use `flutter run` to start the app on your connected device or emulator.
4. **Play with the Calculator**: Input numbers and operators to perform calculations. The expression will be shown on the top line, and the result will be displayed as you press numbers and operators.

---

### Why Use Redux Here?

- **State Management**: Using Redux allows us to manage state in a scalable way. Every user interaction updates the state predictably, and the UI automatically responds to these state changes.
- **Separation of Concerns**: Logic and UI are separated. The reducer takes care of business logic (e.g., calculating results), while the UI only displays the state.