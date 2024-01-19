import 'package:flutter/material.dart';
import 'package:flutter_state_management_comparison/models/post.dart';
import 'package:flutter_state_management_comparison/views/home_page/components/like_bottomsheet.dart';

import '../../../constants/assets.dart';

class HeaderSection extends StatefulWidget {
  final List<Post> posts;
  final Function(bool value, int index) onLikedUpdated;

  const HeaderSection({Key? key, required this.posts, required this.onLikedUpdated})
      : super(key: key);

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            MyAssets.instagramLogo,
            width: 112,
          ),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      LikeButtonSheet(posts: widget.posts, onLikedUpdated: widget.onLikedUpdated));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: Text(
              'Total Like Counter: ${widget.posts.isEmpty ? 0 : widget.posts.map((e) => e.likes).reduce((a, b) => a + b)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
          // SizedBox(
          //   child: Row(
          //     children: [
          //       Image.asset(MyAssets.addIcon, width: 24,),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 20),
          //         child: Image.asset(MyAssets.heartIcon, width: 24,),
          //       ),
          //       Image.asset(MyAssets.messageIcon, width: 24,),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
