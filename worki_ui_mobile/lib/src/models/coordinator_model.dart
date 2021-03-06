import 'package:worki_ui/src/models/user_model.dart';

class Coordinators {
  List<Coordinator> items = new List();
  Coordinators();
  Coordinators.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      final movie = new Coordinator.fromJson(item);
      items.add(movie);
    }
  }
}

class Coordinator extends User {

  String companyId;
  Coordinator(){

  }

  Coordinator.fromJson(Map<String, dynamic> json) {
    id                  = json['id'];
    email               = json['email'];
    password            = json['password'];
    city                = json['city'];
    gender              = json['gender'];
    name                = json['name'];
    birthDate =
        json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null;
    creationDate        = json['creationDate'] != null
        ? DateTime.parse(json['creationDate'])
        : null;
    modificationDate    = json['modificationDate'] != null
        ? DateTime.parse(json['modificationDate'])
        : null;
    phone               = json['phone'];
    profilePic          = json['profilePic'] != null ? json['profilePic'] : '';
    roles               = json['roles'] != null ? json['roles'].cast<String>() : [];
    fireUID             = json['fireUID'];
    devices             = json['devices'] != null ? json['devices'].cast<String>() : [];
    isActive            = json['isActive'];
    isNewUser           = json['isNewUser'];
    companyId           = json['companyId'];
  }

  Map<String, dynamic> toJson() {
    String birth = birthDate != null ? birthDate.toIso8601String() : null;
    String creation =
        creationDate != null ? creationDate.toIso8601String() : null;
    String modification =
        modificationDate != null ? modificationDate.toIso8601String() : null;
    
    return {
      'id': id,
      'email': email,
      'password': password,
      'city': city,
      'gender': gender,
      'name': name,
      'birthDate': birth,
      'creationDate': creation,
      'modificationDate': modification,
      'phone': phone,
      'profilePic': profilePic,
      'roles': roles,
      'fireUID': fireUID,
      'devices': devices,
      'isActive' : isActive,
      'isNewUser' :isNewUser,
      'companyId': companyId,
    };
  }
}
