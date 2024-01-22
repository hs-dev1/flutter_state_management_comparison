import 'package:flutter/material.dart';
import 'package:flutter_state_management_comparison/models/post.dart';
import 'package:flutter_state_management_comparison/views/home_page/components/circular_profile_widget.dart';
import 'package:flutter_state_management_comparison/widgets/post_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/assets.dart';

class PostSection extends StatefulWidget {
  const PostSection({Key? key, required this.post, required this.index}) : super(key: key);
  final Post post;
  final int index;

  @override
  State<PostSection> createState() => _PostSectionState();
}

class _PostSectionState extends State<PostSection> {
  late Post post;
  int selectedPostIndex = 0;
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => '${match[1]},';

  @override
  void initState() {
    post = widget.post;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      width: MediaQuery.of(context).size.width,
      decoration:
          BoxDecoration(border: Border(top: BorderSide(color: Colors.black.withOpacity(0.1)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircularProfileWidget(
                asset: post.profilePicture,
                name: post.username,
                isPost: true,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(post.username),
              const Spacer(),
              Image.asset(
                MyAssets.moreIcon,
                width: 24,
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: MediaQuery.of(context).size.height * .4,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  selectedPostIndex = index;
                });
              },
              itemCount: post.posts.length,
              itemBuilder: (context, index) {
                return Image.network(
                  post.posts[index],
                  fit: BoxFit.fill,
                  frameBuilder: (BuildContext context, Widget child, int? frame,
                      bool? wasSynchronouslyLoaded) {
                    // Frame builder logic (if needed)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: child,
                    );
                  },
                  loadingBuilder:
                      (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    // Loading builder logic
                    if (loadingProgress == null) {
                      // Image fully loaded
                      return child;
                    } else if (loadingProgress.expectedTotalBytes != null &&
                        loadingProgress.cumulativeBytesLoaded <
                            loadingProgress.expectedTotalBytes!) {
                      // Image still loading, display a loading indicator
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!,
                        ),
                      );
                    } else {
                      // Handle other cases, e.g., if the image failed to load
                      return Center(
                        child: Text('Failed to load image'),
                      );
                    }
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  final postProvider = Provider.of<PostProvider>(context, listen: false);
                  postProvider.updateLike(
                      widget.index, postProvider.posts[widget.index].likes == 1 ? 0 : 1);
                },
                child: Image.asset(
                  MyAssets.heartIcon,
                  color: (post.likes == 1) ? Colors.redAccent : null,
                  width: 24,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Image.asset(
                  MyAssets.commentIcon,
                  width: 24,
                ),
              ),
              Image.asset(
                MyAssets.messageIcon,
                width: 24,
              ),
              if (post.posts.length == 1) const Spacer(flex: 1),
              if (post.posts.length != 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    post.posts.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Container(
                        width: selectedPostIndex == index ? 6 : 6,
                        height: selectedPostIndex == index ? 6 : 6,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selectedPostIndex == index ? Colors.amber : Colors.grey),
                      ),
                    ),
                  ),
                ),
              const Spacer(flex: 2),
              Image.asset(MyAssets.saveIcon, width: 24),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            // "${post.likes.toString().replaceAllMapped(reg, mathFunc)} likes",
            "${post.likes.toString()} likes",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: "${post.username} ",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14),
              ),
              TextSpan(text: post.caption, style: const TextStyle(color: Colors.black)),
              TextSpan(text: "...more", style: TextStyle(color: Colors.black.withOpacity(0.4)))
            ]),
          ),
          const SizedBox(height: 8),
          Text(
            "View all ${post.comments.toString().replaceAllMapped(reg, mathFunc)} comments",
            // "View all ${post.comments.toString()} comments",
            style: TextStyle(
                color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w500, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(MyAssets.storyPersons[0], width: 28),
              const SizedBox(width: 8),
              Text(
                "Add a comment...",
                style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.5)),
              ),
              const Spacer(),
              const Text("❤"),
              const SizedBox(width: 12),
              const Text("🙌")
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "1 day ago",
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 10, color: Colors.black.withOpacity(0.5)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
