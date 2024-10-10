import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux_example/like_comment_vm.dart';

class LikeCommentPage extends StatelessWidget {
  final TextEditingController commentController = TextEditingController();

  LikeCommentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Like and Comment App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Like Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<LikeCommentVM>(
                  builder: (context, model, child) {
                    return IconButton(
                      icon: Icon(
                        model.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: model.isLiked ? Colors.red : Colors.grey,
                        size: 40,
                      ),
                      onPressed: () => model.toggleLike(),
                    );
                  },
                ),
                const SizedBox(width: 10),
                Consumer<LikeCommentVM>(
                  builder: (context, model, child) {
                    return Text(
                      '${model.likeCount} likes',
                      style: const TextStyle(fontSize: 20),
                    );
                  },
                ),
              ],
            ),

            // Comment Input Section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        labelText: "Add a comment",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<LikeCommentVM>(context, listen: false)
                          .addComment(commentController.text);
                      commentController.clear();
                    },
                    child: const Text("Post"),
                  ),
                ],
              ),
            ),

            // Display Comments
            Expanded(
              child: Consumer<LikeCommentVM>(
                builder: (context, model, child) {
                  return model.comments.isEmpty
                      ? const Center(child: Text("No comments yet."))
                      : ListView.builder(
                          itemCount: model.comments.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(model.comments[index]),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
