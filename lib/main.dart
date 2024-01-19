import 'package:flutter/material.dart';
import 'package:flutter_state_management_comparison/views/home_page/home_page.dart';
import 'package:flutter_state_management_comparison/widgets/inherited_home_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'State Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PostProvider(child: HomePage()),
    );
  }
}

class PostProvider extends StatelessWidget {
  final Widget child;
  const PostProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return InheritedHomeWidget(posts: const [], child: child);
  }
}
