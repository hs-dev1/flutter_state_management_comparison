import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  final store = Store<int>(
    counterReducer,
    initialState: 0,
  );
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<int> store;
  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<int>(
      store: store,
      child: const MaterialApp(
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // int _counter = 0;

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
            StoreConnector<int, String>(
              converter: (store) => store.state.toString(),
              builder: (context, count) {
                return Text(
                  count,
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => StoreProvider.of<int>(context).dispatch(IncrementAction()),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () => StoreProvider.of<int>(context).dispatch(DecrementAction()),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class IncrementAction {}

class DecrementAction {}

int counterReducer(int state, dynamic action) {
  if (action is IncrementAction) {
    return state + 1;
  } else if (action is DecrementAction) {
    return state - 1;
  }
  return state;
}
