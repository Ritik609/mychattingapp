import 'package:flutter/material.dart';
import 'package:mychattingapp/views/signin.dart';
import 'package:mychattingapp/views/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  createState() => AuthenticateState();
}

class AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn)
      return SignIn(toggleView);
    else
      return SignUp(toggleView);
  }
}
