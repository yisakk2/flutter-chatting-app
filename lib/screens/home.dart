// models
import 'package:chatting_app/models/firebase_provider.dart';
// screens
import 'package:chatting_app/screens/chat.dart';
import 'package:chatting_app/screens/friend.dart';
import 'package:chatting_app/screens/menu.dart';
import 'package:chatting_app/screens/signin.dart';
// widgets
// pakages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [Friend(), Chat(), Menu()];
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // _loggedOut() {
  //   Navigator.pushNamed(context, '/signin');
  // }

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of(context);

    return fp.getUser() == null ? SignIn() : Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white30,
        selectedFontSize: 9,
        unselectedFontSize: 9,
        onTap: _onTap,
        currentIndex: _currentIndex,
        backgroundColor: Colors.black87,
        items: [
          new BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: '친구'),
          new BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline_rounded), label: '채팅'),
          new BottomNavigationBarItem(icon: Icon(Icons.menu), label: '메뉴'),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
