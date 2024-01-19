import 'package:flutter/widgets.dart';
import 'package:flutter_state_management_comparison/models/post.dart';

// ignore: must_be_immutable
class InheritedHomeWidget extends InheritedWidget {
  List<Post> posts;

  InheritedHomeWidget({
    super.key,
    required this.posts,
    required Widget child,
  }) : super(child: child);

  static InheritedHomeWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedHomeWidget>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  // static InheritedHomeWidget of(BuildContext context) {
  //   final InheritedHomeWidget? result =
  //       context.dependOnInheritedWidgetOfExactType<InheritedHomeWidget>();
  //   assert(result != null, 'No InheritedHomeWidget found in context');
  //   return result!;
  // }

  // @override
  // bool updateShouldNotify(InheritedWidget oldWidget) {
  //   return posts != (oldWidget as InheritedHomeWidget).posts;
  // }
}
