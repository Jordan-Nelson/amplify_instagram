import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/models/ModelProvider.dart';
import 'package:amplify_instagram/utils/storage_utils.dart';
import 'package:amplify_instagram/utils/user_utils.dart';
import 'package:flutter/material.dart';

class CreatPost extends StatefulWidget {
  const CreatPost({Key? key, required this.imageFiles}) : super(key: key);
  final List<File> imageFiles;

  @override
  _CreatPostState createState() => _CreatPostState();
}

class _CreatPostState extends State<CreatPost> {
  String caption = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Post'),
        ),
        body: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                SizedBox(
                  height: 250,
                  child: Stack(
                    children: [
                      Image.file(widget.imageFiles[0]),
                      if (widget.imageFiles.length > 1)
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.view_array,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Caption'),
                  onChanged: (value) {
                    setState(() {
                      this.caption = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () async {
                    try {
                      String postId = UUID.getUUID();
                      User user = await getCurrentUser();
                      List<String> imageKeys = [];
                      for (var imageFile in widget.imageFiles) {
                        String imageKey = await uploadImage(
                          file: imageFile,
                          postId: postId,
                        );
                        imageKeys.add(imageKey);
                      }
                      Post post = Post(
                        id: postId,
                        caption: this.caption,
                        user: user,
                        imageKeys: imageKeys,
                      );
                      await Amplify.DataStore.save(post);

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
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red[900],
                          content: Text(
                            'There was an issue creating the post',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Create'),
                )
              ],
            ),
          ),
        ));
  }
}
