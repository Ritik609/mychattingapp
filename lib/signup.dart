import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widget/widget.dart';
import 'package:flutter/material.dart';

import 'chatRoom.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Authmethods auth = new Authmethods();
  DataBaseMethods database=new DataBaseMethods();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signMeUp() {
    if (formKey.currentState.validate()) {
       Map<String,String>userMap={
              "name":userNameController.text,
              "email":emailController.text,
            };
      setState(
        () {
          isLoading = true;
        },
      );
      auth.SignUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) { 
           
            database.uploadUserInfo(userMap);
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));});
    }
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(context),
      body: isLoading
          ? Container(child: Center(child: CircularProgressIndicator()))
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Form(
                            key: formKey,
                            child: Column(children: [
                              TextFormField(
                                validator: (value) {
                                  if (value.length == 0 || value.length < 4)
                                    return "Please Enter Username of atleast 4 character length";
                                  else
                                    return null;
                                },
                                controller: userNameController,
                                style: inputFieldtextStyle(),
                                decoration: textFieldInputdeoration("username"),
                                keyboardType: TextInputType.name,
                              ),
                              TextFormField(
                                validator: (value) {
                                  Pattern pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value))
                                    return 'Enter Valid Email';
                                  else
                                    return null;
                                },
                                controller: emailController,
                                style: inputFieldtextStyle(),
                                keyboardType: TextInputType.emailAddress,
                                decoration: textFieldInputdeoration("email"),
                              ),
                              TextFormField(
                                validator: (val) {
                                  if (val.length < 6)
                                    return "Please Enter strong Password(atleast 6 character long)";
                                  else
                                    return null;
                                },
                                obscureText: true,
                                controller: passwordController,
                                style: inputFieldtextStyle(),
                                decoration: textFieldInputdeoration("password"),
                              ),
                            ])),
                        SizedBox(height: 16.0),
                        GestureDetector(
                          onTap: () {
                            signMeUp();
                          },
                          child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  const Color(0xff007EF4),
                                  const Color(0xff2A75BC),
                                ]),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text("Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ))),
                        ),
                        SizedBox(height: 16),
                        Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text("Sign Up with Google",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 17,
                                ))),
                        SizedBox(height: 16),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have account?",
                                  style: mediumTextStyle()),
                              GestureDetector(
                                onTap: () {
                                  widget.toggle();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text("Sign In",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        decoration: TextDecoration.underline,
                                      )),
                                ),
                              )
                            ]),
                        SizedBox(height: 50),
                      ],
                    )),
              ),
            ),
    );
  }
}
