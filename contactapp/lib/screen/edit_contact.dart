import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import '../model/Contact.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class EditContact extends StatefulWidget {

  //1].
  final String id;
  EditContact(this.id);

  @override
  _EditContactState createState() => _EditContactState(id);
}

class _EditContactState extends State<EditContact> {

  //2].
  String id;
  _EditContactState(this.id);

  //3].
  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';
  String _address = '';
  String _photoUrl;

  //4]. handle text editing controller
  TextEditingController _fnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _poController = TextEditingController();
  TextEditingController _emController = TextEditingController();
  TextEditingController _adController = TextEditingController();

  //5].
  bool isLoading = true;

  //6]. firebase/db helper
  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();

  //7].
  @override
  void initState() {
    super.initState();
    //get contact from firebase
    this.getContact(id);
  }

  //8].
  getContact(id) async {
    Contact contact;
    _databaseReference.child(id).onValue.listen((event){
      contact = Contact.fromSnapshot(event.snapshot);

      _fnController.text = contact.firstName;
      _lnController.text = contact.lastName;
      _poController.text = contact.phone;
      _emController.text = contact.email;
      _adController.text = contact.address;

      setState(() {
        _firstName = contact.firstName;
        _lastName = contact.lastName;
        _phone = contact.phone;
        _email = contact.email;
        _address = contact.address;
        _photoUrl = contact.photoUrl;

        isLoading = false;
      });
    });
  }

  //12]. update contact
  updateContact(BuildContext context) async {
    if(
      _firstName.isNotEmpty &&
      _lastName.isNotEmpty &&
      _phone.isNotEmpty &&
      _email.isNotEmpty &&
      _address.isNotEmpty
    ){
      Contact contact = Contact.withId(this.id, this._firstName, this._lastName, this._phone, this._email, this._address, this._photoUrl);

      await _databaseReference.child(id).set(contact.toJson());
      navigateToLastScreen(context);
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Field Required'),
            content: Text('All fields are required'),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
    }
  }

  //9]. pick Image
  Future pickImage() async {
    File file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200.0,
      maxWidth: 200.0,
    );
    String fileName = basename(file.path);
    uploadImage(file, fileName);
  }
  //10]. upload image
  void uploadImage(File file, String fileName) async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child(fileName);
    //upload image
    storageReference.putFile(file).onComplete.then((firebaseFile) async{
      var downloadUrl = await firebaseFile.ref.getDownloadURL();
      
      setState(() {
        _photoUrl = downloadUrl;  
      });
    });
  }

  //11].
  navigateToLastScreen(BuildContext context){
    Navigator.pop(context);
  }

  
  //13].
  /* +++++++++++Edit contact UI++++++++++++ */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Contact"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    //image view
                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            this.pickImage();
                          },
                          child: Center(
                            child: Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _photoUrl == "empty"
                                          ? AssetImage("images/placeholder.png")
                                          : NetworkImage(_photoUrl),
                                    ))),
                          ),
                        )),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _firstName = value;
                          });
                        },
                        controller: _fnController,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _lastName = value;
                          });
                        },
                        controller: _lnController,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        controller: _poController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        controller: _emController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _address = value;
                          });
                        },
                        controller: _adController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    // update button
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        padding: EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0),
                        onPressed: () {
                          updateContact(context);
                        },
                        color: Colors.green,
                        child: Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

/*  +++++++++++Edit contact UI ENDS  ++++++++++++ */

}