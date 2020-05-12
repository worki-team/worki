import 'dart:io';

import 'package:worki_ui/src/models/education_model.dart';
import 'package:worki_ui/src/models/physicalProfile_model.dart';
import 'package:worki_ui/src/models/rating_model.dart';
import 'package:worki_ui/src/models/user_model.dart';
import 'package:worki_ui/src/models/workExperience_model.dart';

class Workers {
  List<Worker> items = new List();
  Workers();
  Workers.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      final movie = new Worker.fromJson(item);
      items.add(movie);
    }
  }
}

class Worker extends User {
  int age;
  List<String> allergies;
  String cardId;
  String description;
  String nationality;
  String maritalStatus;
  int secondaryPhone;
  String ocupation;
  String rh;
  String availability;
  List<String> roles;
  List<String> physicalLimitation;
  List<String> languages;
  String personalReference;
  int referencePhone;
  File picFile;
  String referenceEmail;
  List<String> interests;
  List<String> aptitudes;
  List<WorkExperience> workExperience;
  List<Education> education;
  PhysicalProfile physicalProfile;
  List<Rating> rating;
  bool isActive;
  bool isNewUser;
  bool isProfileFinished;

  Worker() {
    this.interests = new List<String>();
    this.aptitudes = new List<String>();
    this.allergies = new List<String>();
    this.physicalLimitation = new List<String>();
    this.languages = new List<String>();
    this.workExperience = new List<WorkExperience>();
    this.education = new List<Education>();
    this.rating = new List<Rating>();
  }

  Worker.fromJson(Map<String, dynamic> json) {
    id                  = json['id'];
    email               = json['email'];
    password            = json['password'];
    city                = json['city'];
    gender              = json['gender'];
    name                = json['name'];
    birthDate           = json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null;
    creationDate        = json['creationDate'] != null ? DateTime.parse(json['creationDate']) : null;
    modificationDate    = json['modificationDate'] != null ? DateTime.parse(json['modificationDate']) : null;
    phone               = json['phone'];
    profilePic          = json['profilePic'] != null ? json['profilePic'] : '';
    roles               = json['roles'] != null ? json['roles'].cast<String>() : [];
    age                 = json['age'];
    allergies           = json['aptitudes'] != null ? json['allergies'].cast<String>() : [];
    cardId              = json['cardId'];
    description         = json['description'];
    nationality         = json['nationality'];
    maritalStatus       = json['maritalStatus'];
    secondaryPhone      = json['secondaryPhone'];
    ocupation           = json['ocupation'];
    rh                  = json['rh'];
    availability        = json['availability'];
    physicalLimitation  = json['physicalLimitation'] != null? json['physicalLimitation'].cast<String>(): [];
    languages           = json['languages'] != null ? json['languages'].cast<String>() : [];
    personalReference   = json['personalReference'];
    referencePhone      = json['referencePhone'];
    referenceEmail      = json['referenceEmail'];
    interests           = json['interests'] != null ? json['interests'].cast<String>() : [];
    aptitudes           = json['aptitudes'] != null ? json['aptitudes'].cast<String>() : [];
    workExperience      = json['workExperience'] != null ? WorkExperiences.fromJsonList(json['workExperience']).items : null;
    education           = json['education'] != null ? Educations.fromJsonList(json['education']).items : null;
    physicalProfile     = json['physicalProfile'] != null ? PhysicalProfile.fromJson(json['physicalProfile']) : null;
    fireUID             = json['fireUID'];
    rating              = json['rating'] != null ? Ratings.fromJsonList(json['rating']).items : [];
    isActive            = json['isActive'];
    isNewUser           = json['isNewUser'];
    isProfileFinished   = json['isProfileFinished'];
  }

  Map<String, dynamic> toJson() {
    List<Map> workExperiences = this.workExperience != null
        ? this.workExperience.map((i) => i.toJson()).toList()
        : null;

    List<Map> educations = this.education != null
        ? this.education.map((i) => i.toJson()).toList()
        : null;
    Map physicalProfileAux =
        this.physicalProfile != null ? this.physicalProfile.toJson() : null;

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
      'age': age,
      'allergies': allergies,
      'cardId': cardId,
      'description': description,
      'nationality': nationality,
      'maritalStatus': maritalStatus,
      'secondaryPhone': secondaryPhone,
      'ocupation': ocupation,
      'rh': rh,
      'availability': availability,
      'physicalLimitation': physicalLimitation,
      'languages': languages,
      'personalReference': personalReference,
      'referencePhone': referencePhone,
      'referenceEmail': referenceEmail,
      'interests': interests,
      'aptitudes': aptitudes,
      'workExperience': workExperiences,
      'education': educations,
      'physicalProfile': physicalProfileAux,
      'fireUID': fireUID,
      'rating': rating,
      'isActive' : isActive,
      'isNewUser' :isNewUser,
      'isProfileFinished' : isProfileFinished
    };
  }

  getAge() {
    if (this.birthDate != null) {
      final now = DateTime.now();
      double difference = now.difference(this.birthDate).inDays / 365;
      return difference.toInt();
    } else {
      return 0;
    }
  }

  double getRating() {
    if (rating.length == 0) {
      return 0;
    }
    return (rating.map((v) => v.value).reduce((a, b) => a + b) / rating.length)
        .toDouble();
  }
}
