import 'package:flutter/material.dart';

const String profile_picture_placeholder_url =
    'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key? key,
    this.maxRadius,
  }) : super(key: key);

  final double? maxRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(profile_picture_placeholder_url),
      maxRadius: this.maxRadius,
      backgroundColor: Colors.grey[300],
    );
  }
}
