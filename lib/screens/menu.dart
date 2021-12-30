// models
import 'package:chatting_app/models/firebase_provider.dart';
// screens
// widgets
import 'package:chatting_app/widgets/progress.dart';
// pakages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _loading = false;

  _buildBody(FirebaseProvider fp) {
    return ListView(
      children: [
        _title()
      ],
    );
  }

  _title() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            '메뉴',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
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
