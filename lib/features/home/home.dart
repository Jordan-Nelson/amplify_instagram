import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/models/ModelProvider.dart';
import 'package:flutter/material.dart';

import 'create_post_icon_button.dart';
import 'news_feed_post.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Post>? posts;

  Future fetchPosts() async {
    List<Post> _posts = await Amplify.DataStore.query(Post.classType);
    setState(() {
      posts = _posts.reversed.toList();
    });
  }

  @override
  void initState() {
    fetchPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          CreatePostIconButton(),
        ],
      ),
      body: posts == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: fetchPosts,
              child: ListView.builder(
                itemCount: posts!.length,
                itemBuilder: (context, index) {
                  return NewsFeedPost(post: posts![index]);
                },
              ),
            ),
    );
  }
}
