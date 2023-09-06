import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:messenger_app/model/message.dart';

class ChatServices extends ChangeNotifier{
  //get instance of auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //send message
  Future<void> sendMessage(String receiverId, String message) async{
    //get current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    //chat room id form current id to receiverrId
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //sort the ids (this ensures the chat room id is always the same for any pair of people)
    String chatRoomId = ids.join("_"); // combine ids into a  single string to use a chatroomID

    //add new message to database
    await _firestore.collection("Chat_rooms")
      .doc(chatRoomId)
      .collection("Messages")
      .add(newMessage.toMap());
  }
  //get message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    //xay dung chat room tu user id (dam bao trong chat room la nhwng ng guwi tin nhan truoc do)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomID = ids.join("_");

    return _firestore
      .collection("Chat_rooms")
      .doc(chatRoomID)
      .collection("Messages")
      .orderBy("timestamp", descending: false)
      .snapshots();
  }
}