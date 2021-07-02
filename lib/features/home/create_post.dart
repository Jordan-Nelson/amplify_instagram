import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/custom_models/ImageObject.dart';
import 'package:amplify_instagram/models/ModelProvider.dart';
import 'package:amplify_instagram/utils/storage_utils.dart';
import 'package:amplify_instagram/utils/user_utils.dart';
import 'package:flutter/material.dart';

class CreatPost extends StatefulWidget {
  const CreatPost({Key? key}) : super(key: key);

  @override
  _CreatPostState createState() => _CreatPostState();
}

class _CreatPostState extends State<CreatPost> {
  String caption = '';
  List<File> imageFiles = [];
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
                SizedBox(
                  height: 100,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo),
                      onPressed: () async {
                        List<File> _imageFiles = await pickImages();
                        setState(() {
                          imageFiles = _imageFiles;
                        });
                      },
                    ),
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
                ElevatedButton(
                  onPressed: () async {
                    try {
                      String postId = UUID.getUUID();
                      User user = await getCurrentUser();
                      List<ImageObject> images = [];
                      for (var imageFile in imageFiles) {
                        ImageObject imageObject = await uploadImage(
                          file: imageFile,
                          postId: postId,
                        );
                        images.add(imageObject);
                      }
                      Post post = Post(
                        id: postId,
                        caption: this.caption,
                        user: user,
                        images: images,
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
