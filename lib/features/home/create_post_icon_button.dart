import 'package:amplify_instagram/utils/storage_utils.dart';
import 'package:flutter/material.dart';

import 'create_post.dart';

class CreatePostIconButton extends StatelessWidget {
  const CreatePostIconButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        pickImages().then((files) {
          if (files.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatPost(imageFiles: files),
              ),
            );
          }
        });
      },
      icon: Icon(Icons.add),
    );
  }
}
