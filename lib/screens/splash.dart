import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redux_example/screens/login.dart';
import 'package:redux_example/screens/product_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // ignore: use_build_context_synchronously
    Future.delayed(Durations.extralong4, () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductPage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
