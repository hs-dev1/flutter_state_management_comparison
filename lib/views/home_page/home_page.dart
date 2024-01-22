// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_state_management_comparison/api_service/api_service.dart';
import 'package:flutter_state_management_comparison/views/home_page/components/header_section.dart';
import 'package:flutter_state_management_comparison/views/home_page/components/story_listview.dart';
import 'package:flutter_state_management_comparison/widgets/post_provider.dart';
import 'package:get/get.dart';

import 'components/post_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(PostController());
  final ScrollController scrollController = ScrollController();
  bool isLoading = true;
  int offset = 0;

  @override
  void initState() {
    ApiService.getPosts(offset, 3).then((_posts) {
      controller.posts.value = _posts;
      offset += 10;
      setState(() {});
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        ApiService.getPosts(offset, 10).then((_posts) {
          if (_posts.isEmpty) {
            isLoading = false;
          }
          controller.posts.addAll(_posts);
          offset += 10;
          setState(() {});
        });
      }
    });

    super.initState();
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
              child: Obx(() {
                return ListView.builder(
                  controller: scrollController,
                  itemCount: controller.posts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == controller.posts.length && isLoading) {
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
                      post: controller.posts[index],
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
              await ApiService.getPosts(offset, 3).then((_posts) {
                controller.posts.value = _posts;
                offset += 10;
                controller.update();
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
