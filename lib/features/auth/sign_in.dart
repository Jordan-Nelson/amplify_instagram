import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

import '../../app_root.dart';
import 'sign_up.dart';

class SignInView extends StatefulWidget {
  SignInView({this.initialUsername = '', this.initialPassword = ''});
  @override
  _SignInViewState createState() => _SignInViewState();
  final String initialUsername;
  final String initialPassword;
}

class _SignInViewState extends State<SignInView> {
  String username = '';
  String password = '';

  void signIn(String username, String password) async {
    try {
      SignInResult res = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return AuthenticatedRoot();
          },
        ),
      );
    } on AuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[900],
          content: Text(
            'Error: ' + e.message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    this.username = this.widget.initialUsername;
    this.password = this.widget.initialPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                initialValue: this.username,
                decoration: InputDecoration(labelText: 'Username'),
                onChanged: (value) {
                  setState(() {
                    this.username = value;
                  });
                },
              ),
              TextFormField(
                initialValue: this.password,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    this.password = value;
                  });
                },
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('No Account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => SignUpView(
                                initialPassword: this.password,
                                initialUsername: this.username,
                              ),
                            ),
                          );
                        },
                        child: Text('Sign Up'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signIn(this.username, this.password);
                    },
                    child: Text('Sign In'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
