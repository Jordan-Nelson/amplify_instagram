import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/models/User.dart';

Future<User> getCurrentUser() async {
  String userId = (await Amplify.Auth.getCurrentUser()).userId;
  List<User> users = (await Amplify.DataStore.query(
    User.classType,
    where: User.ID.eq(userId),
  ));
  User user = users.first;
  return user;
}
