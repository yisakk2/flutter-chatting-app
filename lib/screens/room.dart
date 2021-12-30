// models
import 'package:chatting_app/models/firebase_provider.dart';
import 'package:chatting_app/models/messages.dart';
// screens
// widgets
import 'package:chatting_app/widgets/progress.dart';
// pakages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Room extends StatefulWidget {
  const Room({Key? key, this.users}) : super(key: key);
  final users;

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  bool _loading = false;
  final TextEditingController chatController = TextEditingController();

  _buildBody(FirebaseProvider fp) {
    return fp.getMessageRoom() == null ? Container() : StreamBuilder(
      // stream: fp.streamMessages(fp.getMessageRoom()!.id),
      stream: FirebaseFirestore.instance.collection('messageRooms').doc(fp.getMessageRoom()!.id).collection('messages').orderBy('createdAt').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        var data = snapshot.requireData as QuerySnapshot;
        // List<Messages> messages = [];
        List<Row> lists = [];
        data.docs.forEach((value) {
          Messages temp = Messages.fromDocument(value);
          lists.add(_messages(temp));
        });

        // return Container();
        return ListView(
          children: lists,
        );
      },
    );
  }

  _chatBottom(FirebaseProvider fp) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      color: Colors.white10,
      child: TextField(
        controller: chatController,
        style: TextStyle(color: Colors.black, fontSize: 14),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.indigo),
              borderRadius: BorderRadius.circular(25)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
              borderRadius: BorderRadius.circular(25)
          ),
        ),
        onSubmitted: (String str) {
          _sendMessage(fp);
        },
      ),
    );
  }

  _sendMessage(FirebaseProvider fp) {
    if (fp.getMessageRoom() == null) {
      fp.createMessageRoom(widget.users, chatController.text);
    }
    else {
      fp.sendMessage(chatController.text);
    }
    chatController.text = "";
  }

  // _messages(DocumentSnapshot doc) {
  _messages(Messages message) {
    return Row(
      mainAxisAlignment: message.userId == widget.users.myId ? MainAxisAlignment.end : MainAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            // 메세지 텍스트
            Container(
              margin: message.userId == widget.users.myId ? EdgeInsets.fromLTRB(8, 4, 10, 4) : EdgeInsets.fromLTRB(10, 4, 8, 4),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: message.userId == widget.users.myId ? Colors.indigo : Colors.grey
              ),
              // color: Colors.white10,
              child: Text(message.text),
              // child: Text(doc['text']),
            ),
            // 메세지 화살표
            message.userId == widget.users.myId ? _myStack() : _friendStack(),
          ],
        )
      ],
    );
  }

  _myStack() {
    return  Positioned(
      top: 7,
      right: 9,
      child: Container(
        width: 12,
        height: 6,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.indigo
        ),
      ),
    );
  }

  _friendStack() {
    return  Positioned(
      top: 7,
      left: 9,
      child: Container(
        width: 12,
        height: 6,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: Colors.grey
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.users.friendNickname),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            fp.setMessageRoom(null);
            Navigator.pop(context);
          },
        ),
      ),
      body: _loading ? circularProgress() : _buildBody(fp),
      bottomNavigationBar: _chatBottom(fp),
    );
  }
}
