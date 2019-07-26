import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'edit_contact.dart';
import '../model/Contact.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewContact extends StatefulWidget {
  //1].
  final String id;
  ViewContact(this.id);

  @override
  _ViewContactState createState() => _ViewContactState(id);
}

class _ViewContactState extends State<ViewContact> {

  //2].
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  //3].
  String id;
  _ViewContactState(this.id);
  Contact _contact;
  bool isLoading = true;

  //4].
  getContact(id) async {
    _databaseReference.child(id).onValue.listen((event){
      setState(() {
        _contact = Contact.fromSnapshot(event.snapshot);
        isLoading = false;
      });
    });
  }

  //5].
  @override
  void initState() {
    super.initState();
    this.getContact(id);
  }
  //6].call action
  callAction(String number) async {
    String url = 'tel:$number';
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'Could not call $number';
    }
  }
  //7].sms action
  smsAction(String number) async {
    String url = 'sms:$number';
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'Could not send sms to $number';
    }
  }
  //10].delete
  deleteContact(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Delete?'),
          content: Text('Delete Contact?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _databaseReference.child(id).remove();
                navigateToLastScreen();
              },
            )
          ],
        );
      }
    );
  }
  //9].
  navigateToEditScreen(id){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return EditContact(id);
    }));
  }
  //8].
  navigateToLastScreen(){
    Navigator.pop(context);
  }
  
  //11].
  /* ++++++++++++View contact UI++++++++++++++++ */
    @override
    Widget build(BuildContext context) {
      // wrap screen in WillPopScreen widget
      return Scaffold(
        appBar: AppBar(
          title: Text("View Contact"),
        ),
        body: Container(
          child: isLoading
          ? Center(
            child: CircularProgressIndicator(),
          )
          : ListView(
          children: <Widget>[
            // header text container
            Container(
              height: 200.0,
              child: Image(
                image: _contact.photoUrl == "empty"
                  ? AssetImage("assets/logo.png")
                  : NetworkImage(_contact.photoUrl),
                fit: BoxFit.contain,
              ),
            ),
                  
            //name
            Card(
              elevation: 2.0,
              child: Container(
                margin: EdgeInsets.all(20.0),
                width: double.maxFinite,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.perm_identity, color: Colors.green),
                    Container(
                      width: 10.0,
                    ),
                    Text(
                      "${_contact.firstName} ${_contact.lastName}",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          
            // phone
            Card(
              elevation: 2.0,
              child: Container(
                margin: EdgeInsets.all(20.0),
                width: double.maxFinite,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.phone, color: Colors.green),
                    Container(
                      width: 10.0,
                    ),
                    Text(
                      _contact.phone,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          
            // email
            Card(
              elevation: 2.0,
              child: Container(
                margin: EdgeInsets.all(20.0),
                width: double.maxFinite,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.email, color: Colors.green),
                    Container(
                      width: 4.0
                    ),
                    Text(
                      _contact.email,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          
            // address
            Card(
              elevation: 2.0,
              child: Container(
                margin: EdgeInsets.all(20.0),
                width: double.maxFinite,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.home, color: Colors.green,),
                    Container(
                      width: 10.0,
                    ),
                    Text(
                      _contact.address,
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          
            // call and sms
            Card(
              elevation: 2.0,
              child: Container(
                margin: EdgeInsets.all(20.0),
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      iconSize: 30.0,
                      icon: Icon(Icons.phone, color: Colors.green,),
                      color: Colors.red,
                      onPressed: () {
                        callAction(_contact.phone);
                      },
                    ),
                    IconButton(
                      iconSize: 30.0,
                      icon: Icon(Icons.message),
                      color: Colors.green,
                      onPressed: () {
                        smsAction(_contact.phone);
                      },
                    )
                  ],
                ),
              ),
            ),
                  
            // edit and delete
            Card(
              elevation: 2.0,
              child: Container(
                margin: EdgeInsets.all(20.0),
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      iconSize: 30.0,
                      icon: Icon(Icons.edit),
                      color: Colors.green,
                      onPressed: () {
                        navigateToEditScreen(id);
                      },
                    ),
                    IconButton(
                      iconSize: 30.0,
                      icon: Icon(Icons.delete),
                      color: Colors.green,
                      onPressed: () {
                        deleteContact();
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
 /* +++++++++++View contact UI ENDS ++++++++++++ */
}