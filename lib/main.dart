import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LikeCommentPage(),
    );
  }
}

class LikeCommentPage extends StatefulWidget {
  @override
  _LikeCommentPageState createState() => _LikeCommentPageState();
}

class _LikeCommentPageState extends State<LikeCommentPage> {
  bool isLiked = false;
  int likeCount = 0;
  List<String> comments = [];
  TextEditingController commentController = TextEditingController();

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void addComment() {
    String comment = commentController.text;
    if (comment.isNotEmpty) {
      setState(() {
        comments.add(comment);
        commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Like and Comment App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Like Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                    size: 40,
                  ),
                  onPressed: toggleLike,
                ),
                SizedBox(width: 10),
                Text(
                  '$likeCount likes',
                  style: TextStyle(fontSize: 20),
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
                      decoration: InputDecoration(
                        labelText: "Add a comment",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: addComment,
                    child: Text("Post"),
                  ),
                ],
              ),
            ),

            // Display Comments
            Expanded(
              child: comments.isEmpty
                  ? Center(child: Text("No comments yet."))
                  : ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(comments[index]),
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
