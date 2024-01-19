// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_state_management_comparison/api_service/api_service.dart';
import 'package:flutter_state_management_comparison/models/post.dart';
import 'package:flutter_state_management_comparison/views/home_page/components/header_section.dart';
import 'package:flutter_state_management_comparison/views/home_page/components/story_listview.dart';

import 'components/post_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  final ScrollController scrollController = ScrollController();
  bool isLoading = true;
  int offset = 0;

  @override
  void initState() {
    ApiService.getPosts(offset, 3).then((_posts) {
      posts = _posts;
      offset += 10;
      setState(() {});
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        ApiService.getPosts(offset, 10).then((_posts) {
          if (_posts.isEmpty) {
            isLoading = false;
          }
          posts.addAll(_posts);
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
            HeaderSection(
              posts: posts,
              onLikedUpdated: (value, index) {
                posts[index].likes = !value ? 0 : 1;
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == posts.length && isLoading) {
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
                    post: posts[index],
                    index: index,
                    onLikedUpdated: (index) {
                      posts[index].likes = posts[index].likes == 1 ? 0 : 1;
                      setState(() {});
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await ApiService.getPosts(offset, 3).then((_posts) {
                posts = _posts;
                offset += 10;
                setState(() {});
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

// class Api {
  // static Future<List<Post>> getPosts({required int offset}) async {
  //   final response = await get(
  //       Uri.parse('https://api.slingacademy.com/v1/sample-data/users?offset=$offset&limit=10'));
  //   List<dynamic> users = jsonDecode(response.body)['users'];
  //   log("message ${users.map((user) => Post.fromJson(user)).toList()}");
  //   return users.map((user) => Post.fromJson(user)).toList();
  // }
// }
