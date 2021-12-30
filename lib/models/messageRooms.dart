import 'package:cloud_firestore/cloud_firestore.dart';

class MessageRooms {
  final String id;
  final bool isGroup;
  final DateTime lastMessagedAt;
  final String lastMessagedText;
  final List<dynamic> userIds;
  final Map<String, dynamic> userInfo;

  MessageRooms({
    required this.id,
    required this.isGroup,
    required this.lastMessagedAt,
    required this.lastMessagedText,
    required this.userIds,
    required this.userInfo,
  });

  factory MessageRooms.fromDocument(DocumentSnapshot doc) {
    final getDocs = doc.data() as Map<dynamic, dynamic>;
    return MessageRooms(
      id: doc.id,
      isGroup: getDocs['isGroup'],
      lastMessagedAt: getDocs['lastMessagedAt'].toDate(),
      lastMessagedText: getDocs['lastMessagedText'],
      userIds: getDocs['userIds'],
      userInfo: getDocs['userInfo']
    );
  }

  factory MessageRooms.fromJson(Map<String, dynamic> json) => MessageRooms(
      id: json['id'],
      isGroup: json['isGroup'],
      lastMessagedAt: json['lastMessagedAt'].toDate(),
      lastMessagedText: json['lastMessagedText'],
      userIds: json['userIds'],
      userInfo: json['userInfo']
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'isGroup': isGroup,
    'lastMessagedAt': lastMessagedAt,
    'lastMessagedText': lastMessagedText,
    'userIds': userIds,
    'userInfo': userInfo,
  };
}

class shortMessageRooms {
  final String roomId;
  final String myId;
  final String myNickname;
  final String friendId;
  final String friendNickname;

  shortMessageRooms({
    required this.roomId,
    required this.myId,
    required this.myNickname,
    required this.friendId,
    required this.friendNickname
  });
}