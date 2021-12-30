import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final bool check;
  final DateTime createdAt;
  final String text;
  final String userId;

  Messages({
    required this.check,
    required this.createdAt,
    required this.text,
    required this.userId
  });

  factory Messages.fromDocument(DocumentSnapshot doc) {
    final getDocs = doc.data() as Map<dynamic, dynamic>;
    return Messages(
      check: getDocs['check'],
      createdAt: getDocs['createdAt'].toDate(),
      text: getDocs['text'],
      userId: getDocs['userId'],
    );
  }
}