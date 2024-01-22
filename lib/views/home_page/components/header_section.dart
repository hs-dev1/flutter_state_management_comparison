import 'package:flutter/material.dart';
import 'package:flutter_state_management_comparison/views/home_page/components/like_bottomsheet.dart';
import 'package:flutter_state_management_comparison/widgets/post_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/assets.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({Key? key}) : super(key: key);

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
              showModalBottomSheet(context: context, builder: (cntxt) => LikeButtonSheet());
              setState(() {});
            },
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: Consumer<PostProvider>(builder: (context, postProvider, widget) {
              return Text(
                'Total Like Counter: ${postProvider.posts.isEmpty ? 0 : postProvider.posts.map((e) => e.likes).reduce((a, b) => a + b)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              );
            }),
          )
        ],
      ),
    );
  }
}
