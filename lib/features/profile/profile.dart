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
          return Center(
            child: Text('An error occured loading the users profile data'),
          );
        } else if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('@' + snapshot.data!.username),
              actions: [
                ClearDataStoreIconButton(),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  OutlinedButton(
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

class ClearDataStoreIconButton extends StatelessWidget {
  const ClearDataStoreIconButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
                          child: Text('Clear local data'),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                          ),
                          onPressed: () {
                            Amplify.DataStore.clear();
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
      icon: Icon(Icons.menu),
    );
  }
}
