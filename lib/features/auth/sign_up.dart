import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

import 'confirm_sign_up.dart';
import 'sign_in.dart';

class SignUpView extends StatefulWidget {
  SignUpView({required this.initialUsername, required this.initialPassword});
  @override
  _SignUpViewState createState() => _SignUpViewState();
  final String initialUsername;
  final String initialPassword;
}

class _SignUpViewState extends State<SignUpView> {
  String username = '';
  String name = '';
  String email = '';
  String password = '';
  void signUp(
      String username, String name, String email, String password) async {
    try {
      Map<String, String> userAttributes = {
        'email': email,
        'name': name,
        'preferred_username': username,
      };

      SignUpResult res = await Amplify.Auth.signUp(
        username: username,
        password: password,
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );

      if (res.nextStep.signUpStep == "CONFIRM_SIGN_UP_STEP") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => ConfirmSignUpView(
                    initialUsername: this.username,
                    initialPassword: this.password,
                  )),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SignInView(
              initialUsername: this.username,
              initialPassword: this.password,
            ),
          ),
        );
      }
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
        title: Text('Sign Up'),
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
                initialValue: this.name,
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  setState(() {
                    this.name = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    this.email = value;
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
                      Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => SignInView(
                                initialUsername: this.username,
                                initialPassword: this.password,
                              ),
                            ),
                          );
                        },
                        child: Text('Sign In'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signUp(
                        this.username,
                        this.name,
                        this.email,
                        this.password,
                      );
                    },
                    child: Text('Sign Up'),
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
