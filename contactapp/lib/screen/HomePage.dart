import 'package:flutter/material.dart';
import 'add_contact.dart';
import 'view_contact.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //1].
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  //2].
  navigateToAddScreen(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return AddContact();
    }));
  }
  //3].
  navigateToViewScreen(id){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return ViewContact(id);
    }));
  }
  
  //4].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact App"),
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: _databaseReference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index){
            return GestureDetector(
              onTap: () {
                navigateToViewScreen(snapshot.key);
              },
              child: Card(
                color: Colors.white,
                elevation: 2.0,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: snapshot.value['photoUrl'] == "empty"
                              ? AssetImage("assets/logo.png")
                              : NetworkImage(snapshot.value['photoUrl']),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              " ${snapshot.value['firstName']} ${snapshot.value['lastName']} ",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " ${snapshot.value['phone']} ",
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: navigateToAddScreen,
      ),
    );
  }
}