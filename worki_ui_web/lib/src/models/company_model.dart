//import 'dart:ffi';

import 'package:worki_ui/src/models/administrator_model.dart';
import 'package:worki_ui/src/models/rating_model.dart';

class Companies{
  List<Company> items = new List();
  Companies();
  Companies.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      final movie = new Company.fromJson(item);
      items.add(movie);
    }
  }
}

class Company {
  
  String id;
  String name;
  String description;
  String address;
  double latitude;
  double longitude;
  String city;
  int nit;
  int phone;
  int secondaryPhone;
  String category;
  String profilePic;
  List<Rating> rating;

  Company(){
    this.rating = new List<Rating>();
  }

  Company.fromJson(Map<String, dynamic> json) {
    id          = json['id'];
    name        = json['name'];
    description = json['description'];
    address     = json['address'];
    latitude    = json['latitude'];
    longitude   = json['longitude'];
    city        = json['city'];
    nit            = json['nit'];
    phone          = json['phone'];
    secondaryPhone = json['secondaryPhone'];
    category    = json['category'];
    profilePic  = json['profilePic'] == null ? '': json['profilePic'];
    rating      = json['rating'] != null ? Ratings.fromJsonList(json['rating']).items : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'description' : description,
      'address' : address,
      'latitude' : latitude,
      'longitude' : longitude,
      'city' : city,
      'nit'    : nit,
      'phone'    : phone,
      'secondaryPhone'    : secondaryPhone,
      'category' : category,
      'profilePic' : profilePic,
      'rating' : rating,
    };
  }

  double getRating(){
    if(rating.length == 0){
      return 0;
    }
    return (rating.map((v) => v.value).reduce((a,b) => a+b) / rating.length).toDouble();
  }
  
}