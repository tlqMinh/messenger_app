import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/components/chat_bongbong.dart';
import 'package:messenger_app/components/my_text_box.dart';
import 'package:messenger_app/services/chat/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({super.key, required this.receiverUserEmail, required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController _controllerMessages = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage() async{
    //gui tn khi co tin nhan
    if(_controllerMessages.text.isNotEmpty){
      await _chatServices.sendMessage(widget.receiverUserID, _controllerMessages.text);
      //xoa tin nhan sai khi da gui trong khung ghi
      _controllerMessages.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Column(
        children: [
          //messages
          Expanded(child: _buildMessageList(),
          ),

          //user input
          _buildMessageInput(),
          SizedBox(height: 25,),
        ],
      ),
    );
  }

  //message list
  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chatServices
        .getMessages(widget.receiverUserID, _auth.currentUser!.uid),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return Text("Error" + snapshot.error.toString());
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading...");
        }
        return ListView(
          children: snapshot
                      .data!
                      .docs.map(
                        (document) => _buildMessageItem(
                          document))
                          .toList(),
        );
      },
    );
  }

  //message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //vi tri tin nhan gui
    var alignment = (data["senderId"] == _auth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data["senderId"] == _auth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: (data["senderId"] == _auth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(data["senderEmail"],),
            SizedBox(height: 5,),
            ChatBongBong(message: data["message"]),
          ],
        ),
      ),
    );
  }

  //message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextBox(
              obscureText: false,
              controller: _controllerMessages,
              hintText: "Enter message",
            )
          ),
          IconButton(
            onPressed: sendMessage,
            icon: Icon(Icons.arrow_upward, size: 40,),
          ),
        ],
      ),
    );
  }
}


