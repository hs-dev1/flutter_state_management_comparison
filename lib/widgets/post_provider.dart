import 'package:flutter/material.dart';
import 'package:flutter_state_management_comparison/models/post.dart';

class PostProvider extends ChangeNotifier {
  List<Post> posts = [];

  PostProvider();

  void updatePosts(List<Post> newPosts) {
    posts = newPosts;
    notifyListeners();
  }

  void addPosts(List<Post> newPosts) {
    posts.addAll(newPosts);
    notifyListeners();
  }

  void updateLike(int index, int value) {
    posts[index].likes = value;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
