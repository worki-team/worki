  import 'dart:core';
class User {
  String        id;
  String        email;
  String        password;
  String        city;
  String        gender;
  String        name;
  DateTime      birthDate;
  DateTime      creationDate;
  DateTime      modificationDate;
  int           phone;
  String        profilePic;
  List<String>  roles;
  String fireUID;
  List<String> devices;
  bool isActive;
  bool isNewUser;

  User(){
    this.roles = new List<String>();
    this.devices = new List<String>();
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    city = json['city'];
    gender = json['gender'];
    name = json['name'];
    birthDate           = json['birthDate']        != null ? DateTime.parse(json['birthDate']) :null;
    creationDate        = json['creationDate']     != null ? DateTime.parse(json['creationDate']) :null;
    modificationDate    = json['modificationDate'] != null ? DateTime.parse(json['modificationDate']) :null;
    phone               = json['phone'];
    profilePic          = json['profilePic'] != null ? json['profilePic'] : '';
    roles               = json['roles'] != null ? json['roles'].cast<String>() : [];
    fireUID             = json['fireUID'];
    devices             = json['devices'] != null ? json['devices'].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    String birth        = birthDate != null ? birthDate.toIso8601String() : null;
    String creation = creationDate != null ? creationDate.toIso8601String() : null;
    String modification     = modificationDate != null ? modificationDate.toIso8601String() : null;
    return {
      'id':                 id,
      'email':              email,
      'password':           password,
      'city':            city,
      'gender':             gender,
      'name':               name,
      'birthDate':          birth,
      'creationDate':       creation,
      'modificationDate':   modification,
      'phone':              phone,
      'profilePic':         profilePic,
      'roles':              roles,
      'fireUID':            fireUID,
      'devices':            devices,
    };
  }

}