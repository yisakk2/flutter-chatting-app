// models
import 'package:chatting_app/models/firebase_provider.dart';
import 'package:chatting_app/models/messageRooms.dart';
// screens
// widgets
import 'package:chatting_app/widgets/progress.dart';
// pakages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  bool _loading = false;
  String id = '';

  _buildBody(FirebaseProvider fp) {
    setState(() {
      id = fp.getUser()!.uid;
    });

    return ListView(
      children: [
        _title(),
        _roomList(fp),
      ],
    );
  }

  _title() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            '채팅',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  _noRoom() {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 120,
      child: Center(
        child: Text(
          '채팅방이 존재하지 않습니다.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20
          )
        ),
      ),
    );
  }

  _roomList(FirebaseProvider fp) {
    return StreamBuilder(
      stream: fp.streamMessageRooms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return Container();
      },
    );
  }

  _rooms(FirebaseProvider fp, MessageRooms room) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundImage: AssetImage('profile_pic.jpg'),
      ),
      title: Text(''),
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of(context);

    return Scaffold(
      body: _loading ? circularProgress() : _buildBody(fp),
    );
  }
}
