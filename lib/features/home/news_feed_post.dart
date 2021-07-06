import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/app_models/image_object.dart';
import 'package:amplify_instagram/components/amplify_storage_image.dart';
import 'package:amplify_instagram/components/user_avatar.dart';
import 'package:amplify_instagram/models/ModelProvider.dart';
import 'package:amplify_instagram/utils/post_utils.dart';
import 'package:amplify_instagram/utils/snackbar_utils.dart';
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
              PostCaption(post: post, userSnapshot: snapshot),
              PostCommentsView(post: post),
              AddCommentButton(post: post)
            ],
          ),
        );
      },
    );
  }
}

class PostCommentsView extends StatelessWidget {
  const PostCommentsView({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Comment>>(
        stream: streamTopComments(post),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.length > 0) {
            return Column(
                children: snapshot.data!.map((comment) {
              return CaptionView(
                  username: comment.user!.username, content: comment.content);
            }).toList());
          }
          return Container();
        });
  }
}

class AddCommentButton extends StatelessWidget {
  const AddCommentButton({
    Key? key,
    required this.post,
  }) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: getCurrentUser(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                UserAvatar(maxRadius: 12),
                TextButton(
                  onPressed: snapshot.hasData
                      ? () {
                          showModalBottomSheet(
                            useRootNavigator: true,
                            context: context,
                            builder: (context) {
                              return AddCommentModalBottomSheet(
                                post: post,
                                user: snapshot.data!,
                              );
                            },
                          );
                        }
                      : null,
                  child: Text(
                    'Add a comment ...',
                    style: TextStyle(fontSize: 14),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class AddCommentModalBottomSheet extends StatefulWidget {
  const AddCommentModalBottomSheet({
    Key? key,
    required this.post,
    required this.user,
  }) : super(key: key);

  final Post post;
  final User user;

  @override
  _AddCommentModalBottomSheetState createState() =>
      _AddCommentModalBottomSheetState();
}

class _AddCommentModalBottomSheetState
    extends State<AddCommentModalBottomSheet> {
  String content = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                UserAvatar(),
                SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add a comment ...',
                    ),
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        content = value.trim();
                      });
                    },
                  ),
                ),
                TextButton(
                  onPressed: content == ''
                      ? null
                      : () async {
                          try {
                            await Amplify.DataStore.save(
                              Comment(
                                content: content,
                                post: widget.post,
                                user: widget.user,
                              ),
                            );
                            showSuccessSnackBar(context, 'Comment added!');
                          } catch (e) {
                            showErrorSnackBar(context,
                                'An error occured adding the comment.');
                          }
                          Navigator.of(context).maybePop();
                        },
                  child: Text('Post'),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewInsets.bottom,
          ),
        ],
      ),
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
    return CaptionView(username: username, content: post.caption);
  }
}

class CaptionView extends StatelessWidget {
  const CaptionView({
    Key? key,
    required this.username,
    required this.content,
  }) : super(key: key);

  final String username;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, bottom: 8),
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
                TextSpan(text: content),
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
            useRootNavigator: true,
            context: context,
            builder: (context) {
              return SafeArea(
                child: Column(
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
                ),
              );
            });
      },
      icon: Icon(Icons.more_horiz),
    );
    Widget leading = UserAvatar();
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
            children: widget.post.imageObjects
                .map((imageObjectString) =>
                    ImageObject.fromJsonString(imageObjectString))
                .map((imageObject) => AmplifyStorageImage(
                      imageObject: imageObject,
                    ))
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
            if (widget.post.imageObjects.length > 1)
              DotsIndicator(
                dotsCount: widget.post.imageObjects.length,
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
