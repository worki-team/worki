 class NotificationModel{
   String to;
   Map<String,String> notification;
   Map<String,String> data;

   NotificationModel({
     this.to,
     this.notification,
     this.data
   });

  Map <String, dynamic> toJson(){
    return {
      'to': to,
      'notification': notification,
      'data': data
    };
  }
 }