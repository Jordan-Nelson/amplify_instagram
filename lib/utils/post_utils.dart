import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/models/ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';

Stream<List<Comment>> streamTopComments(Post post) async* {
  var events = Amplify.DataStore.observe(Comment.classType);
  List<Comment> initialComments =
      await Amplify.DataStore.query(Comment.classType).then((comments) =>
          comments
              .where((comment) => comment.post!.id == post.id)
              .take(2)
              .toList());
  List<Comment> comments = [];
  for (var comment in initialComments) {
    User user = (await Amplify.DataStore.query(User.classType,
            where: User.ID.eq(comment.user!.id)))
        .first;
    comments.add(comment.copyWith(user: user));
  }
  yield comments;
  await for (var event in events) {
    if (event.eventType == EventType.create &&
        event.item.post!.id == post.id &&
        !comments.map((item) => item.id).contains(event.item.id)) {
      User user = (await Amplify.DataStore.query(User.classType,
              where: User.ID.eq(event.item.user!.id)))
          .first;
      comments.add(event.item.copyWith(user: user));
      yield comments;
    }
  }
}
