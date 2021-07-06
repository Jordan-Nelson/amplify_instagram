import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/models/ModelProvider.dart';
import 'package:amplify_instagram/utils/snackbar_utils.dart';
import 'package:amplify_instagram/utils/storage_utils.dart';
import 'package:amplify_instagram/utils/user_utils.dart';
import 'package:flutter/material.dart';

class CreatPost extends StatefulWidget {
  const CreatPost({Key? key, required this.imageFiles, this.onCreatePost})
      : super(key: key);
  final List<File> imageFiles;
  final Function? onCreatePost;

  @override
  _CreatPostState createState() => _CreatPostState();
}

class _CreatPostState extends State<CreatPost> {
  String caption = '';
  bool _loading = false;
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
                Stack(
                  children: [
                    SizedBox(
                      height: 350,
                      child: Image.file(
                        widget.imageFiles[0],
                        fit: BoxFit.cover,
                      ),
                    ),
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
                  onPressed: _loading
                      ? null
                      : () async {
                          setState(() {
                            _loading = true;
                          });
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
                            if (widget.onCreatePost != null) {
                              widget.onCreatePost!();
                            }
                            Navigator.of(context).pop();
                            showSuccessSnackBar(context, 'Post created!');
                          } catch (e) {
                            print(e);
                            showErrorSnackBar(
                              context,
                              'There was an issue creating the post',
                            );
                          }
                          setState(() {
                            _loading = false;
                          });
                        },
                  child: _loading
                      ? Center(
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: Colors.grey[900],
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Text('Create'),
                )
              ],
            ),
          ),
        ));
  }
}
