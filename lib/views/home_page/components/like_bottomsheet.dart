import 'package:flutter/material.dart';
import 'package:flutter_state_management_comparison/models/post.dart';

class LikeButtonSheet extends StatefulWidget {
  final List<Post> posts;
  final Function(bool value, int index) onLikedUpdated;

  const LikeButtonSheet({super.key, required this.posts, required this.onLikedUpdated});

  @override
  State<LikeButtonSheet> createState() => _LikeButtonSheetState();
}

class _LikeButtonSheetState extends State<LikeButtonSheet> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.posts.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(widget.posts[index].username),
        trailing: Switch(
          value: widget.posts[index].likes == 1,
          onChanged: (value) {
            widget.onLikedUpdated(value, index);
            // setState(() {});
          },
        ),
        leading: CircleAvatar(backgroundImage: NetworkImage(widget.posts[index].profilePicture)),
      ),
    );
  }
}
