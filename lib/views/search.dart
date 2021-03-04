import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mychattingapp/helper/constants.dart';
import 'package:mychattingapp/services/database.dart';
import 'package:mychattingapp/views/conversationScreen.dart';
import 'package:mychattingapp/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  QuerySnapshot searchSnapshot;
  TextEditingController searchEditingController = new TextEditingController();

  initiateSearch() async {
    print(searchEditingController.text);
    await databaseMethods
        .getUserByUsername(searchEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  DatabaseMethods databaseMethods = DatabaseMethods();
  createChatRoomAndStartConversation(String userName) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoom = {
        "users": users,
        "chatroomId": chatRoomId
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoom);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else
      print("You cannot send message to yourself");
  }

  Widget searchList() {
    return searchSnapshot != null
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: searchSnapshot.documents.length,
                itemBuilder: (context, index) {
                  return searchTile(
                      searchSnapshot.documents[index].data['name'].toString(),
                      searchSnapshot.documents[index].data['email'].toString());
                }),
          )
        : Text("Null value");
  }

  Widget searchTile(String username, String email) {
    return Container(
        child: Row(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                email,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            createChatRoomAndStartConversation(username);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text("message"),
          ),
        )
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: Container(
          child: ListView(
            children: [
              Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: searchEditingController,
                      style: mediumTextStyle(),
                      decoration: InputDecoration(
                        hintText: "Search username...",
                        hintStyle: TextStyle(
                          color: Colors.white24,
                        ),
                        border: InputBorder.none,
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        print("tap");
                        initiateSearch();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF),
                            ]),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.search)),
                    ),
                  ],
                ),
              ),
              searchList(),
            ],
          ),
        ));
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else
    return "$a\_$b";
}
