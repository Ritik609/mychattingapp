import 'package:chat_app/services/database.dart';
import 'package:chat_app/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  QuerySnapshot searchSnapshot;
  TextEditingController searchEditingController = new TextEditingController();
  DataBaseMethods databaseMethods = new DataBaseMethods();

  initiateSearch() async{
    print(searchEditingController.text);
    await databaseMethods.getUserByUsername(searchEditingController.text).then((val) {
     searchSnapshot = val;
      setState(() {
       //  searchSnapshot = val;
        searchList();
         });

    });
    
  }

  Widget searchList() {
    

     return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.documents.length,
            itemBuilder: (context, index) {
              print(index);
              return SearchTile(
                  email: searchSnapshot.documents[index].data['email'].toString(),
                  username:
                      searchSnapshot.documents[index].data['name'].toString());
            }):Text("Null value");
        // : Container(
        //   color:Colors.red,
        //     child: Text("Hello"),
        //   );
  }

  @override
  void initState() {
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(context),
        body: Container(
          child: Column(
            children: [
              Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: searchEditingController,
                      decoration: InputDecoration(
                        hintText: "Search username...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        print("tap");
                        initiateSearch();
                        //print(searchSnapshot.docs[0].data()["email"].toString());
                        
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
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.search)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class SearchTile extends StatelessWidget {
  final String username;
  final String email;
  SearchTile({this.username, this.email});
  @override
  Widget build(BuildContext context) {
    print(email);
    return Container(
        child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: inputFieldtextStyle(),
            ),
            Text(
              email,
              style: inputFieldtextStyle(),
            ),
          ],
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text("message"),
        )
      ],
    ));
  }
}
