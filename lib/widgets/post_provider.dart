import 'package:flutter_state_management_comparison/api_service/api_service.dart';
import 'package:flutter_state_management_comparison/models/post.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  RxList<Post> posts = RxList();
  int offset = 0;
  RxBool isLoading = true.obs;

  PostController();

  void getPosts() {
    ApiService.getPosts(offset, 10).then((newPosts) {
      updatePosts(newPosts);
      offset += 10;
    });
  }

  void onScrollEnd() {
    ApiService.getPosts(offset + 10, 10).then((newPosts) {
      if (newPosts.isEmpty) {
        isLoading.value = false;
      }
      addPosts(newPosts);
      offset += 10;
    });
  }

  void updatePosts(List<Post> newPosts) {
    posts.value = newPosts;
  }

  void addPosts(List<Post> newPosts) {
    posts.addAll(newPosts);
  }

  void updateLike(int index, int value) {
    Post post = posts.elementAt(index);
    posts.removeAt(index);
    post.likes = value;
    posts.insert(index, post);
  }

  // void update() {}
}
