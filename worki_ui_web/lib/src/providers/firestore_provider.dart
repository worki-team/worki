import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worki_ui/src/models/user_model.dart';

class FirestoreProvider {
  final Firestore _fireStore = Firestore.instance;

  getMemberListChat(chatId, userId) async {
    final data = await _fireStore
        .collection('chats')
        .document(chatId)
        .collection('members')
        .where('id', isEqualTo: userId)
        .getDocuments();
    return data;
  }

  getUser(userId) async {
    final data = await _fireStore
        .collection('users')
        .where('id', isEqualTo: userId)
        .getDocuments();
    return data;
  }

  getChatByKey(chatKey) async {
    final data = _fireStore
        .collection('chats').document(chatKey).get();
    return data;
  }

  addUser(String id, String name, String profilePic, String rol) async {
    getUser(id).then((docRef) {
      if (docRef.documents.length > 0) {
        print('ya está guardado');
      } else {
        print('no está guardado');
        _fireStore.collection('users').add({
          'id': id,
          'name': name,
          'profilePic': profilePic,
          'rol': rol
        }).then((docRef) {
          print("Document written with ID: " + docRef.documentID);
        }).catchError((error) {
          print("Error adding document: " + error);
        });
      }
    });
  }

  createChat(String id,String groupName, String profilePic, List<User> userIds) async {
    final resp = await _fireStore.collection('chats').add({
      'id':id,
      'groupName': groupName,
      'profilePic': profilePic,
    }).then((docRef) {
      print("Document written with ID: " + docRef.documentID);
      userIds.forEach((user) async {
        addUser(user.id, user.name, user.profilePic, user.roles[0]);
        addMemberToChat(docRef.documentID, user.id);
      });
      return docRef;
    }).catchError((error) {
      print("Error adding document: " + error);
    });
  }

  updateUser(String id, String name, String profilePic, String rol) async {
    _fireStore.collection('users').where('id', isEqualTo: id).getDocuments().then((docRef){
      _fireStore.collection('users').document(docRef.documents[0].documentID).updateData(
        {
          'name': name,
          'profilePic': profilePic,
          'rol': rol
        }
      );
    });
  }

  addMemberToChat(String chatId, String id) async {
    final resp = await _fireStore
        .collection('chats')
        .document(chatId)
        .collection('members')
        .add({
      'id': id,
    }).then((docRef) {
      print("Document written with ID: " + docRef.documentID);
    }).catchError((error) {
      print("Error adding document: " + error);
    });
    return resp;
  }

  getChatKey(String chatId) async {
  var chatDoc;
  await _fireStore.collection('chats').where('id', isEqualTo: chatId).getDocuments().then((docRef){
      chatDoc = docRef.documents[0];
    });
  return chatDoc;
  }

  getChatByEventId(eventId) async {
    final data = await _fireStore
        .collection('chats')
        .where('id', isEqualTo: eventId)
        .getDocuments();
    return data;
  }

  addMemberToChatWithEventId(String eventId, String id) async {
   getChatByEventId(eventId).then((docRef) async {
          await addMemberToChat(docRef.documents[0].documentID, id);
          return true;
        }).catchError((error) {
      print("Error adding document: " + error);
    });
  }

  deleteMemberFromChat(String eventId, String workerId) async {
     
    await getChatByEventId(eventId).then((docRef) async {
      
      final data = await _fireStore.collection('chats')
        .document(docRef.documents[0].documentID)
        .collection('members')
        .where('id', isEqualTo: workerId)
        .getDocuments();
        
        data.documents.forEach((document) async{
          await _fireStore.collection('chats')
            .document(docRef.documents[0].documentID)
            .collection('members')
            .document(document.documentID)
            .delete();
        });
        return true;
      }).catchError((error) {
      print("Error adding document: " + error);
    });
  }

  deleteChat(String eventId) async {
     await getChatByEventId(eventId).then((docRef) async {
          print('REF:'+docRef.documents[0].documentID);
           await _fireStore.collection('chats').document(docRef.documents[0].documentID).delete();
          return true;
        }).catchError((error) {
      print("Error adding document: " + error);
    });
  }
}
