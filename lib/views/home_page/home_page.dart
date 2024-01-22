// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_state_management_comparison/api_service/api_service.dart';
import 'package:flutter_state_management_comparison/views/home_page/components/header_section.dart';
import 'package:flutter_state_management_comparison/views/home_page/components/story_listview.dart';
import 'package:flutter_state_management_comparison/widgets/post_provider.dart';
import 'package:provider/provider.dart';

import 'components/post_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Post> posts = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = true;
  int offset = 0;

  @override
  void initState() {
    final postProvider = Provider.of<PostProvider>(context, listen: false);

    ApiService.getPosts(offset, 3).then((_posts) {
      postProvider.posts = _posts;
      offset += 10;
      setState(() {});
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        ApiService.getPosts(offset, 10).then((_posts) {
          if (_posts.isEmpty) {
            isLoading = false;
          }
          postProvider.posts.addAll(_posts);
          offset += 10;
          setState(() {});
        });
      }
    });

    super.initState();
  }

  Widget header() {
    return const Column(
      children: [
        StoryListView(),
        SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            HeaderSection(),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<PostProvider>(builder: (context, postProvider, widget) {
                return ListView.builder(
                  controller: scrollController,
                  itemCount: postProvider.posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == postProvider.posts.length && isLoading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    }
                    return PostSection(
                      index: index,
                      post: postProvider.posts[index],
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final postProvider = Provider.of<PostProvider>(context, listen: false);

              await ApiService.getPosts(offset, 3).then((_posts) {
                postProvider.posts = _posts;
                offset += 10;
                postProvider.update();
                
              });
            },
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            onPressed: () async {
              scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 500), curve: Curves.linear);
            },
            child: const Icon(Icons.vertical_align_top_outlined),
          ),
        ],
      ),
    );
  }
}
