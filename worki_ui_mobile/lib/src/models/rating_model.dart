class Ratings {
    List<Rating> items = new List();
    Ratings();
    
    Ratings.fromJsonList(List<dynamic> jsonList){
      if(jsonList == null) return;
      for(var item in jsonList){
        final rating = new Rating.fromJson(item);
        items.add(rating);
      }
    }
}

class Rating {
  String userId;
  int value;
  String comment;

  Rating(){

  }

  Rating.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    value = json['value'];
    comment = json['comment'];
  }
  Map<String,dynamic> toJson(){
    return {
      'userId': userId,
      'value' : value,
      'comment' : comment
    };
  }
}
