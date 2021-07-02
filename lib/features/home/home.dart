import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/models/ModelProvider.dart';
import 'package:amplify_instagram/utils/user_utils.dart';
import 'package:flutter/material.dart';

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
      posts = _posts;
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
                  return ListTile(
                    title: Text(posts![index].title),
                    subtitle: FutureBuilder<User>(
                        future: getUser(posts![index].user!.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text('@' + snapshot.data!.username);
                          } else if (snapshot.hasError) {
                            return Text('failed to find post author');
                          }
                          return Text('loading ...');
                        }),
                  );
                },
              ),
            ),
    );
  }
}

class CreatPost extends StatefulWidget {
  const CreatPost({Key? key}) : super(key: key);

  @override
  _CreatPostState createState() => _CreatPostState();
}

class _CreatPostState extends State<CreatPost> {
  String title = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create Post'),
        ),
        body: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onChanged: (value) {
                    setState(() {
                      this.title = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    User user = await getCurrentUser();
                    Post post = Post(title: this.title, user: user);
                    Amplify.DataStore.save(post).then((value) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green[700],
                          content: Text(
                            'Post created!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }).catchError((e) {
                      print(e.message);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red[900],
                          content: Text(
                            'Error: ' + e.message,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    });
                  },
                  child: Text('Create'),
                )
              ],
            ),
          ),
        ));
  }
}
