import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import '../auth/sign_in.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Amplify.Auth.getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<AuthUser> snapshot) {
        if (snapshot.hasError) {
          // todo
        } else if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'username: ' + (snapshot.data?.username ?? ''),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Amplify.Auth.signOut().then((value) {
                      Navigator.of(context).pushReplacement(
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
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
