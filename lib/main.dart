import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux_example/like_comment_page.dart';
import 'package:redux_example/like_comment_vm.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LikeCommentVM(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LikeCommentPage(),
    );
  }
}
