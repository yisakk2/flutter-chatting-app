// models
import 'package:chatting_app/models/firebase_provider.dart';
import 'package:chatting_app/models/messageRooms.dart';
// screens
import 'package:chatting_app/screens/room.dart';
// widgets
import 'package:chatting_app/widgets/progress.dart';
// pakages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Friend extends StatefulWidget {
  const Friend({Key? key}) : super(key: key);

  @override
  _FriendState createState() => _FriendState();
}

class _FriendState extends State<Friend> {
  bool _loading = false;

  _buildBody(FirebaseProvider fp) {
    return ListView(
      children: [
        _title(),
        _me(),
        _divider(),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 6),
          child: Text(
            '친구',
            style: TextStyle(
              color: Colors.white30,
              fontSize: 13
            ),
          ),
        ),
        _friendList(fp),
      ],
    );
  }

  _title() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            '친구',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  _me() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('profile_pic.jpg'),
          ),
          SizedBox(width: 12,),
          Text(
            '이삭',
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  _divider() {
    return Padding(padding: EdgeInsets.fromLTRB(16, 12, 16, 12), child: Divider(height: 1,),);
  }

  _friendList(FirebaseProvider fp) {
    return FutureBuilder(
      future: fp.getFriendList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var friends = snapshot.data! as List<shortMessageRooms>;
          List<ListTile> lists = [];

          friends.forEach((data) {
            lists.add(_friends(fp, data));
          });

          return Column(
            children: lists,
          );
        } else {
          return circularProgress();
        }
      },
    );
  }

  _friends(FirebaseProvider fp, shortMessageRooms friend) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage('profile_pic.jpg'),
      ),
      title: Text(friend.friendNickname),
      onTap: () {
        fp.setMessageRoomWithShortMessageRoom(friend);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Room(users: friend,))
        );
      },
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
