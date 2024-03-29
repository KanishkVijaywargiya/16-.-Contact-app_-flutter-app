import 'package:firebase_database/firebase_database.dart';

//1].
class Contact{
  String _id;
  String _firstName;
  String _lastName;
  String _phone;
  String _email;
  String _address;
  String _photoUrl;

  //2]. Constructor for adding
  Contact(this._firstName, this._lastName, this._phone, this._email, this._address, this._photoUrl);

  //3]. Constructor for editing
  Contact.withId(this._id, this._firstName, this._lastName, this._phone, this._email, this._address, this._photoUrl);

  //4]. Getters => get value out of this class
  String get id => this._id;
  String get firstName => this._firstName;
  String get lastName => this._lastName;
  String get phone => this._phone;
  String get email => this._email;
  String get address => this._address;
  String get photoUrl => this._photoUrl;

  //5]. Setters => set value to this class
  set firstName(String firstName){
    this._firstName = firstName + " ";
  }
  set lastName(String lastName){
    this._lastName = lastName;
  }
  set phone(String phone){
    this._phone = phone;
  }
  set email(String email){
    this._email = email;
  }
  set address(String address){
    this._address = address;
  }
  set photoUrl(String photoUrl){
    this._photoUrl = photoUrl;
  }

  //6]. Creating object from snapshot into Contact class & vice~versa
  Contact.fromSnapshot(DataSnapshot snapshot){
    this._id = snapshot.key;
    this._firstName = snapshot.value['firstName'];
    this._lastName = snapshot.value['lastName'];
    this._phone = snapshot.value['phone'];
    this._email = snapshot.value['email'];
    this._address = snapshot.value['address'];
    this._photoUrl = snapshot.value['photoUrl'];
  }
  //7].
  Map<String, dynamic> toJson(){
    return{
      "firstName": _firstName,
      "lastName": _lastName,
      "phone": _phone,
      "email": _email,
      "address": _address,
      "photoUrl": _photoUrl,
    };
  }
}

