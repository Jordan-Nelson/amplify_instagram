import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/models/User.dart';

Future<User> getCurrentUser() async {
  String userId = (await Amplify.Auth.getCurrentUser()).userId;
  return getUser(userId);
}

Future<User> getUser(String id) async {
  List<User> users = (await Amplify.DataStore.query(
    User.classType,
    where: User.ID.eq(id),
  ));
  User user = users.first;
  return user;
}

Future<String> getCurrentUserIdentityId() async {
  String identityId = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true))
      .then((session) => (session as CognitoAuthSession).identityId!);
  return identityId;
}
