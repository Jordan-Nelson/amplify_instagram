import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

import 'sign_in.dart';
import 'sign_up.dart';

class ConfirmSignUpView extends StatefulWidget {
  ConfirmSignUpView(
      {required this.initialUsername, required this.initialPassword});
  @override
  _ConfirmSignUpViewState createState() => _ConfirmSignUpViewState();
  final String initialUsername;
  final String initialPassword;
}

class _ConfirmSignUpViewState extends State<ConfirmSignUpView> {
  String username = '';
  String code = '';

  void signIn(String username, String password) async {
    try {
      await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: code,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SignInView(
            initialUsername: this.username,
            initialPassword: this.widget.initialPassword,
          ),
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Sign Up'),
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
                decoration: InputDecoration(labelText: 'Verification Code'),
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    code = value;
                  });
                },
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => SignUpView(
                            initialPassword: this.widget.initialPassword,
                            initialUsername: this.username,
                          ),
                        ),
                      );
                    },
                    child: Text('Back to Sign Up'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      signIn(this.username, this.code);
                    },
                    child: Text('Confirm Code'),
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
