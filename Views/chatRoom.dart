import 'package:chat_app/Views/search.dart';
import 'package:chat_app/helper/authentic.dart';
import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  Authmethods auth = new Authmethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat_Room"),
        actions: [
          GestureDetector(
            onTap: () {
              auth.signOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Authenticate(),
                  ));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.search),
        onPressed:(){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>SearchScreen()));
        } ),
    );
  }
}
