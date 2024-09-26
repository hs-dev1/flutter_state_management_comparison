# redux_example
# Flutter Redux Counter App

This Flutter application demonstrates state management using Redux. The app features a counter with increment, decrement, and reset functionality, along with a history of counter values.

## Overview of Features Implemented (Level 2)

### Features

- **Increment Counter**: Increase the counter value by tapping the "+" button.
- **Decrement Counter**: Decrease the counter value by tapping the "-" button.
- **Reset Counter**: Reset the counter to zero with a dedicated button.
- **History Tracking**: Maintain a history of all previous counter values.

## Key Concepts Covered

### 1. Redux Principles

- **Store**: 
  - The central repository that holds the state of the application.
  - It acts as a single source of truth for the app’s state.

- **Actions**: 
  - Plain objects that describe an event or intention to change the state.
  - Examples include:
    - `IncrementAction`: Represents the action of increasing the counter.
    - `DecrementAction`: Represents the action of decreasing the counter.
    - `ResetAction`: Represents the action to reset the counter to zero.

- **Reducers**: 
  - Pure functions that take the current state and an action as arguments and return a new state.
  - They specify how the state changes in response to actions, ensuring that state transitions are predictable.

### 2. Application Structure

- **AppState**: 
  - A class that encapsulates the entire state of the application.
  - Includes the current counter value and a list of its history.

### 3. UI Components

- **MyApp**: 
  - The root widget that provides the Redux store to the entire application using `StoreProvider`.

- **MyHomePage**: 
  - The main screen of the app that displays:
    - The current counter value.
    - The history of previous counter values.
    - Buttons for incrementing, decrementing, and resetting the counter.

### 4. State Management

- **State Immutability**: 
  - Redux emphasizes keeping the state immutable. Instead of modifying the existing state, new states are returned from reducers.

- **State Update Flow**:
  1. An action is dispatched (e.g., incrementing the counter).
  2. The reducer processes the action and returns a new state.
  3. The store updates the state and notifies the UI to re-render.

## Getting Started

To run the application, follow these steps:

1. Clone the repository.
2. Navigate to the project directory.
3. Install dependencies using `flutter pub get`.
4. Run the app with `flutter run`.

## Conclusion

This app serves as a foundational example of using Redux for state management in Flutter applications. The principles and patterns learned here can be built upon in future levels to incorporate more complex features and asynchronous actions.

