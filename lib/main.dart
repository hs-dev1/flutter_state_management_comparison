import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<AppState>(
    counterReducer,
    initialState: AppState(counter: 0, history: []),
  );
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;
  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: const MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Test"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StoreConnector<AppState, String>(
              converter: (store) => store.state.counter.toString(),
              builder: (context, count) {
                return Text(
                  count,
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            const SizedBox(height: 12),
            StoreConnector<AppState, List<int>>(
              builder: (context, history) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Value: ${history[index]}'),
                      );
                    },
                  ),
                );
              },
              converter: (store) => store.state.history,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => StoreProvider.of<AppState>(context).dispatch(IncrementAction()),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => StoreProvider.of<AppState>(context).dispatch(DecrementAction()),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => StoreProvider.of<AppState>(context).dispatch(ResetAction()),
            tooltip: 'Reset',
            child: const Icon(Icons.restore_outlined),
          ),
        ],
      ),
    );
  }
}

// Action Classes
class IncrementAction {}

class DecrementAction {}

class ResetAction {}

// App State
class AppState {
  final int counter;
  final List<int> history;

  AppState({required this.counter, required this.history});
}

AppState counterReducer(AppState state, dynamic action) {
  if (action is IncrementAction) {
    return AppState(
      counter: state.counter + 1,
      history: [state.counter + 1, ...state.history],
    );
  } else if (action is DecrementAction) {
    return AppState(
      counter: state.counter - 1,
      history: [state.counter - 1, ...state.history],
    );
  } else if (action is ResetAction) {
    return AppState(
      counter: 0,
      history: [],
    );
  }
  return state;
}
