class Post {
  final String profilePicture;
  final String username;
  final List<String> posts;
  int likes;
  final String caption;
  final int comments;

  Post(
      {required this.profilePicture,
      required this.username,
      required this.posts,
      required this.likes,
      required this.caption,
      required this.comments});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        profilePicture: json['profile_picture'],
        username: json['first_name'],
        posts: [
          json['profile_picture'],
        ],
        likes: 0,
        caption: json['street'],
        comments: json['id'],
      );
}
