import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/models/ModelProvider.dart';
import 'package:amplify_instagram/utils/user_utils.dart';
import 'package:flutter/material.dart';

import 'create_post.dart';

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
          IconButton(
            onPressed: () {
              Amplify.DataStore.clear();
            },
            icon: Icon(
              Icons.delete,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatPost(),
                ),
              );
            },
            icon: Icon(Icons.add),
          ),
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
                  return Card(
                      child: Column(
                    children: [
                      UserListTile(post: posts![index]),
                      PostImagesView(post: posts![index]),
                      ListTile(title: Text(posts![index].caption))
                    ],
                  ));
                },
              ),
            ),
    );
  }
}

class UserListTile extends StatelessWidget {
  const UserListTile({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    Widget trailing = IconButton(
        onPressed: () {
          Amplify.DataStore.delete(post);
        },
        icon: Icon(Icons.delete));
    return FutureBuilder<User>(
      future: getUser(post.user!.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListTile(
            title: Text(snapshot.data!.name),
            subtitle: Text('@' + snapshot.data!.username),
            trailing: trailing,
          );
        } else if (snapshot.hasError) {
          return ListTile(title: Text('failed to find post author'));
        }
        return ListTile(title: Text('loading...'));
      },
    );
  }
}

class PostImagesView extends StatelessWidget {
  const PostImagesView({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 325,
      child: PageView(
        scrollDirection: Axis.horizontal,
        children: post.images
            // .map((e) => ImageObject.fromJsonString(e))
            .map((imageObject) =>
                Image.network(imageObject.url, fit: BoxFit.cover))
            .toList(),
      ),
    );
  }
}
