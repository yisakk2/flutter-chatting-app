// models
// import 'package:chatting_app/models/messageRooms.dart';
import 'package:chatting_app/models/messageRooms.dart';
import 'package:chatting_app/models/users.dart';
// screens
// widgets
// pakages
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Logger logger = Logger();

class FirebaseProvider with ChangeNotifier {
  final FirebaseAuth fAuth = FirebaseAuth.instance;
  final FirebaseFirestore fStore = FirebaseFirestore.instance;
  User? _user;
  MessageRooms? _currentMessageRoom;

  FirebaseProvider() {
    _prepareUser();
  }

  User? getUser() {
    return _user;
  }

  void setUser(User? value) {
    _user = value;
    notifyListeners();
  }

  _prepareUser() {
    if (fAuth.currentUser != null) {
      setUser(fAuth.currentUser);
    }
    else setUser(null);
  }

  MessageRooms? getMessageRoom() {
    return _currentMessageRoom;
  }

  void setMessageRoom(MessageRooms? value) {
    _currentMessageRoom = value;
    notifyListeners();
  }

  void setMessageRoomWithShortMessageRoom(shortMessageRooms? value) async {
    await fStore.collection('messageRooms').doc(value?.roomId).get().then((DocumentSnapshot doc) {
      setMessageRoom(MessageRooms.fromDocument(doc));
    });
  }

  getFriends() async {
    List<String> friendList = [];

    await fStore.collection('users').doc(_user!.uid).get().then((DocumentSnapshot doc) {
      doc['friends'].forEach((data) {
        friendList.add(data);
      });
    });

    return friendList;
    // var snapshots = await FirebaseFirestore.instance.collection('users').where('id', arrayContains: )
  }

  getFriendList() async {
    List<String> friendList = [];
    List<String> nicknameList = [];
    List<shortMessageRooms> lists = [];
    String myId = '';
    String myNickname = '';

    await fStore.collection('users').doc(_user!.uid).get().then((DocumentSnapshot doc) {
      myId = doc['id'];
      myNickname = doc['nickname'];
      doc['friends'].forEach((data) {
        friendList.add(data);
      });
    });

    await fStore.collection('users').doc(_user!.uid).get().then((DocumentSnapshot doc) {
      doc['nicknames'].forEach((data) {
        nicknameList.add(data);
      });
    });

    for (int i = 0; i < friendList.length; i++) {
      String roomId = '';
      await fStore.collection('messageRooms').where('userIds', isEqualTo: [_user!.uid, friendList[i]]).get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((data) {
          roomId = data.id;
        });
      });
      await fStore.collection('messageRooms').where('userIds', isEqualTo: [friendList[i], _user!.uid]).get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((data) {
          roomId = data.id;
        });
      });
      lists.add(shortMessageRooms(roomId: roomId, myId: myId, myNickname: myNickname, friendId: friendList[i], friendNickname: nicknameList[i]));
    }

    return lists;
  }

  getNicknames() async {
    List<String> nicknameList = [];

    await fStore.collection('users').doc(_user!.uid).get().then((DocumentSnapshot doc) {
      doc['nicknames'].forEach((data) {
        nicknameList.add(data);
      });
    });

    return nicknameList;
  }

  // createRoom() async {
  //   var documentSnapshot = await fStore.collection('users').doc(_user!.uid).get();
  //   Users user = Users.fromDocument(documentSnapshot);
  //
  //   return user;
  // }

  createMessageRoom(shortMessageRooms roomInfo, String message) async {
    await fStore.collection('messageRooms').add({
      'isGroup': false,
      'lastMessagedAt': DateTime.now(),
      'lastMessagedText': '',
      'userIds': [_user!.uid, roomInfo.friendId],
      'userInfo': {_user!.uid: roomInfo.friendNickname, roomInfo.friendId: roomInfo.myNickname},
    });

    // MessageRooms? MR;
    await fStore.collection('messageRooms').where('userIds', arrayContainsAny: [_user!.uid, roomInfo.friendId]).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((data) {
        setMessageRoom(MessageRooms.fromDocument(data));
      });
    });

    sendMessage(message);
  }

  sendMessage(String message) async {
    await fStore.collection('messageRooms').doc(_currentMessageRoom!.id).collection('messages').add({
      'check': false,
      'createdAt': DateTime.now(),
      'text': message,
      'userId': _user!.uid,
    });

    await fStore.collection('messageRooms').doc(_currentMessageRoom!.id).set({
      'isGroup': false,
      'lastMessagedAt': DateTime.now(),
      'lastMessagedText': message,
      'userIds': _currentMessageRoom!.userIds,
      'userInfo': _currentMessageRoom!.userInfo,
    });

    notifyListeners();
  }

  streamMessages(String roomId) async* {
    Stream<QuerySnapshot> _messageStream = await fStore.collection('messageRooms').doc(roomId).collection('messages').snapshots();

    yield _messageStream;
  }

  streamMessageRooms() async* {
    Stream<QuerySnapshot> _messageRoomStream = await fStore.collection('messageRooms').snapshots();

    yield _messageRoomStream;
  }

  getMessageRoomList() async {
    List<String> titles = [];

    await fStore.collection('messageRooms').where('userIds', arrayContains: _user!.uid).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        titles.add(doc['userIds']);
      });
    });

    return titles;
  }

  getImageUrl() async {
    var documentSnapshot = await fStore.collection('users').doc(_user!.uid).get();
    Users user = Users.fromDocument(documentSnapshot);
    // var imageUrl = await FirebaseFirestore.instance.collection('users').doc(_user!.uid).toString();
    return user.imageUrl;
  }

  // 이메일/비밀번호로 회원가입
  Future<bool> signUpWithEmail(String email, String password, String passwordCheck, String nickname) async {
    bool flag = true;
    if (password != passwordCheck) flag = false;

    if (flag) {
      try {
        UserCredential result = await fAuth.createUserWithEmailAndPassword(email: email, password: password);
        if (result.user != null) {
          // 인증 메일 전송
          // result.user!.sendEmailVerification();
          await fStore.collection('users').doc(result.user!.uid).set({
            'email': email,
            'imageUrl': 'gs://key-of-music.appspot.com/profile_pic.jpg',
            'nickname': nickname,
            'friends': []
          });
          signOut();
          return true;
        }
        return false;
      } on Exception catch (e) {
        logger.e(e.toString());
        // List<String> result = e.toString().split(", ");
        // setLastFBMessage(result[1]);
        return false;
      }
    } else {
      return false;
    }
  }

  // 이메일/비밀번호로 로그인
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      var result = await fAuth.signInWithEmailAndPassword(email: email, password: password);
      setUser(result.user);
      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      return false;
    }
  }

  // 패스워드 재설정 이메일
  pwResetEmail() async {
    String email = _user!.email as String;
    await fAuth.sendPasswordResetEmail(email: email);
  }

  // 로그아웃
  signOut() async {
    await fAuth.signOut();
    setUser(null);
  }

  // 회원탈퇴
  withdrawalAccount() async {
    await FirebaseFirestore.instance.collection('users').doc(_user!.uid).delete();
    await _user!.delete();
    setUser(null);
  }
}