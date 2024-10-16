import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Stream<int> priceStream() async* {
  // Simulating price updates every 1 second
  for (int price = 100; price <= 1005; price++) {
    await Future.delayed(const Duration(seconds: 1));
    yield price;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<int>(
          create: (_) => priceStream(),
          initialData: 100,
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('StreamProvider Example')),
          body: const PriceUpdates(),
        ),
      ),
    );
  }
}

class PriceUpdates extends StatelessWidget {
  const PriceUpdates({super.key});

  @override
  Widget build(BuildContext context) {
    final seconds = Provider.of<int>(context);

    return Center(
      child: Text('Wait, it will increase the counter after each second. \n Seconds: $seconds'),
    );
  }
}
