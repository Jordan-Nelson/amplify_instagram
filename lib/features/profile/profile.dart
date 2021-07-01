import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import '../auth/sign_in.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Amplify.Auth.getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<AuthUser> snapshot) {
        if (snapshot.hasError) {
          // todo
        } else if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text('@' + snapshot.data!.username)),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Amplify.Auth.signOut().then((value) {
                        Navigator.of(context, rootNavigator: true)
                            .pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => SignInView(),
                          ),
                        );
                      });
                    },
                    child: Text('Sign Out'),
                  ),
                ],
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
