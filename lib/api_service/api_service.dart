import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_state_management_comparison/models/post.dart';
import 'package:http/http.dart';

class ApiService {
  // static Future<List<Post>> getPosts(int offset, int limit) async {
  //   final response = await get(
  //     // Uri.parse("https://api.slingacademy.com/v1/sample-data/users?offset=$offset&limit=$limit"),
  //     Uri.parse("https://api.slingacademy.com/v1/sample-data/users?offset=$offset&limit=10"),
  //   );
  //   // List<dynamic> u = jsonDecode(response.body)['users'];
  //   // // return u.map((users) => Post.fromJson(users)).toList();
  //   // log("response.body ${u}");
  //   List<dynamic> users = jsonDecode(response.body)['users'];
  //   log("message ${users.map((user) => Post.fromJson(user)).toList()}");
  //   return [];
  // }
  static Future<List<Post>> getPosts(int offset, int limit) async {
    final response = await get(
        Uri.parse('https://api.slingacademy.com/v1/sample-data/users?offset=$offset&limit=10'));
    List<dynamic> users = jsonDecode(response.body)['users'];
    log("message ${users.map((user) => Post.fromJson(user)).toList()}");
    return users.map((user) => Post.fromJson(user)).toList();
  }
}
