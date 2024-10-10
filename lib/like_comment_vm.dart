import 'package:flutter/material.dart';

class LikeCommentVM extends ChangeNotifier {
  bool _isLiked = false;
  int _likeCount = 0;
  final List<String> _comments = [];

  bool get isLiked => _isLiked;
  int get likeCount => _likeCount;
  List<String> get comments => _comments;

  void toggleLike() {
    _isLiked = !_isLiked;
    _likeCount += _isLiked ? 1 : -1;
    notifyListeners(); // Notify the UI to update
  }

  void addComment(String comment) {
    if (comment.isNotEmpty) {
      _comments.add(comment);
      notifyListeners(); // Notify the UI to update
    }
  }
}
