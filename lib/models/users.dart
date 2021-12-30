import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String id;
  final String email;
  final String imageUrl;
  final String nickname;
  final List<String> friends;
  final List<String> nicknames;

  Users({
    required this.id,
    required this.email,
    required this.imageUrl,
    required this.nickname,
    required this.friends,
    required this.nicknames
  });

  factory Users.fromDocument(DocumentSnapshot doc) {
    final getDocs = doc.data() as Map<dynamic, dynamic>;
    return Users(
      id: doc.id,
      email: getDocs["email"],
      imageUrl: getDocs["imageUrl"],
      nickname: getDocs["nickname"],
      friends: getDocs["friends"],
      nicknames: getDocs["nicknames"],
    );
  }
}