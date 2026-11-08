import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_app/models/post_model.dart';

Future<Posts> fetchPost() async {
  final response = await http.get(Uri.http('127.0.0.1:8000', 'post/2'));
  if (response.statusCode == 200) {
    return Posts.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Faild to load data');
  }
}

Future<List<Posts>?> fetchAllPosts() async {
  final response = await http.get(Uri.http('127.0.0.1:8000', 'post/'));
  if (response.statusCode == 200) {
    List<Posts> listPosts = List<Posts>.from(
      jsonDecode(response.body).map((x) => Posts.fromJson(x)),
    );
    return listPosts;
  } else {
    throw Exception('Faild to load data');
  }
}

Future<Posts> creatPost(String imageUrl, String caption, int creatorId) async {
  final response = await http.post(
    Uri.http('127.0.0.1:8000', 'post/create_post'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, dynamic>{
      "image_url": imageUrl,
      "image_url_type": "url",
      "caption": caption,
      "creator_id": creatorId,
    }),
  );
  if (response.statusCode == 200) {
    return Posts.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Faild to load data');
  }
}

Future<Posts> deletePost(int id) async {
  final response = await http.delete(
    Uri.http('127.0.0.1:8000', 'post/delete_post/$id'),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 200) {
    return Posts.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Faild to delete data');
  }
}

Future<Posts> updatePost(int id, String caption) async {
  final response = await http.patch(
    Uri.http('127.0.0.1:8000', 'post/update_caption/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(<String, dynamic>{"caption": caption}),
  );
  if (response.statusCode == 200) {
    return Posts.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Faild to load data');
  }
}
