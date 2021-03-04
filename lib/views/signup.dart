import 'package:flutter/material.dart';
import 'package:mychattingapp/helper/helperFunction.dart';
import 'package:mychattingapp/services/auth.dart';
import 'package:mychattingapp/services/database.dart';
import 'package:mychattingapp/views/chatroomsScreen.dart';
import 'package:mychattingapp/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  bool isLoading = false;
  AuthMethods authMethods = AuthMethods();
  HelperFunction helperFunction = HelperFunction();
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  signMeUp() {
    if (formKey.currentState.validate())
      setState(() {
        isLoading = true;
      });

    authMethods
        .signUpWithEmailAndPassword(
            emailTextEditingController.text, passwordTextEditingController.text)
        .then((value) {
      Map<String, String> userInfoMap = {
        "name": userNameTextEditingController.text,
        "email": emailTextEditingController.text
      };
      helperFunction
          .saveUserNameSharedPreference(userNameTextEditingController.text);
      helperFunction
          .saveUserEmailSharedPreference(emailTextEditingController.text);
      databaseMethods.uploadUserInfo(userInfoMap);
      helperFunction.saveUserLoggedInPreference(true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChatRoom()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 50,
                    alignment: Alignment.center,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            style: simpleTextStyle(),
                            controller: userNameTextEditingController,
                            validator: (val) {
                              return val.isEmpty || val.length < 3
                                  ? "Enter Username 3+ characters"
                                  : null;
                            },
                            decoration: textFieldInputDecoration("username"),
                          ),
                          TextFormField(
                            controller: emailTextEditingController,
                            style: simpleTextStyle(),
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Enter correct email";
                            },
                            decoration: textFieldInputDecoration("email"),
                          ),
                          TextFormField(
                            obscureText: true,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("password"),
                            controller: passwordTextEditingController,
                            validator: (val) {
                              return val.length < 6
                                  ? "Enter Password 6+ characters"
                                  : null;
                            },
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                "Forgot Password?",
                                style: simpleTextStyle(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              signMeUp();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xff007EF4),
                                      const Color(0xff2A75BC)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "Sign Up",
                                style: mediumTextStyle(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            child: Text(
                              "Sign Up with Google",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 17),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have account?",
                                style: mediumTextStyle(),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggle();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    " Sign In now",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}
