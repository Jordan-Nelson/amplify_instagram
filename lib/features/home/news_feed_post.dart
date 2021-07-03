import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/components/amplify_storage_image.dart';
import 'package:amplify_instagram/models/ModelProvider.dart';
import 'package:amplify_instagram/utils/user_utils.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

// a news feed post Widget
class NewsFeedPost extends StatelessWidget {
  const NewsFeedPost({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: getUser(post.user!.id),
      builder: (context, snapshot) {
        return Container(
          child: Column(
            children: [
              UserListTile(post: post, userSnapshot: snapshot),
              PostImagesView(post: post),
              PostCaption(post: post, userSnapshot: snapshot)
            ],
          ),
        );
      },
    );
  }
}

class PostCaption extends StatelessWidget {
  const PostCaption({
    Key? key,
    required this.post,
    required this.userSnapshot,
  }) : super(key: key);

  final Post post;
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    String username = userSnapshot.hasData ? userSnapshot.data!.username : '';
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 16),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' '),
                TextSpan(text: post.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserListTile extends StatelessWidget {
  const UserListTile({
    Key? key,
    required this.post,
    required this.userSnapshot,
  }) : super(key: key);

  final Post post;
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    Widget trailing = IconButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text('Delete'),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                        ),
                        onPressed: () {
                          Amplify.DataStore.delete(post);
                          Navigator.of(context).maybePop();
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text('Cancel'),
                        style: ButtonStyle(),
                        onPressed: () {
                          Navigator.of(context).maybePop();
                        },
                      ),
                    ],
                  ),
                ],
              );
            });
      },
      icon: Icon(Icons.more_horiz),
    );
    Widget leading = CircleAvatar(
      backgroundColor: Colors.grey[300],
    );
    if (userSnapshot.hasData) {
      return ListTile(
        leading: leading,
        title: Text(userSnapshot.data!.name),
        subtitle: Text('@' + userSnapshot.data!.username),
        trailing: trailing,
      );
    } else if (userSnapshot.hasError) {
      return ListTile(title: Text('failed to find post author'));
    }
    return ListTile(title: Text('loading...'));
  }
}

class PostImagesView extends StatefulWidget {
  PostImagesView({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  _PostImagesViewState createState() => _PostImagesViewState();
}

class _PostImagesViewState extends State<PostImagesView> {
  double position = 0;
  final PageController _controler = PageController();

  @override
  void initState() {
    _controler.addListener(() {
      setState(() {
        position = _controler.page ?? 0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 350,
          child: PageView(
            controller: _controler,
            scrollDirection: Axis.horizontal,
            children: widget.post.imageKeys
                .map((imageKey) => AmplifyStorageImage(storageKey: imageKey))
                .toList(),
          ),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtonBar(
              buttonPadding: EdgeInsets.zero,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: Icon(Icons.favorite_outline),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: Icon(Icons.mode_comment_outlined),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: Icon(Icons.send_outlined),
                ),
              ],
            ),
            if (widget.post.imageKeys.length > 1)
              DotsIndicator(
                dotsCount: widget.post.imageKeys.length,
                position: position,
              ),
            ButtonBar(
              buttonPadding: EdgeInsets.zero,
              children: [
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: null,
                  icon: Container(),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: null,
                  icon: Container(),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {},
                  icon: Icon(Icons.bookmark_border),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 4),
      ],
    );
  }
}
