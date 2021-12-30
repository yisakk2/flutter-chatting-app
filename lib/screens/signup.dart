// models
import 'package:chatting_app/models/firebase_provider.dart';
// screens
// widgets
import 'package:chatting_app/widgets/alert.dart';
import 'package:chatting_app/widgets/progress.dart';
// pakages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();


  _buildBody(FirebaseProvider fp) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 아이디
              TextFormField(
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: '이메일',
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                    borderRadius: BorderRadius.circular(16)
                  ),
                ),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 10,),
              // 비밀번호 확인
              TextFormField(
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: '비밀번호',
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                    borderRadius: BorderRadius.circular(16)
                  ),
                ),
                controller: passwordController,
                obscureText: true,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 10,),
              // 비밀번호임 확인
              TextFormField(
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: '비밀번호 확인',
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                    borderRadius: BorderRadius.circular(16)
                  ),
                ),
                controller: passwordCheckController,
                obscureText: true,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 10,),
              // 닉네임
              TextFormField(
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: '닉네임',
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                    borderRadius: BorderRadius.circular(16)
                  ),
                ),
                controller: nicknameController,
                onFieldSubmitted: (_) => _signUp(fp),
              ),
              SizedBox(height: 16,),
              // 회원가입 버튼
              Container(
                width: double.infinity,
                height: 60,
                // color: Colors.white,
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(16.0)
                ),
                child: MaterialButton(
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                    ),
                  ),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode()); // 키보드 감춤
                    _signUp(fp);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp(FirebaseProvider fp) async {
    if (emailController.text == '') {
      alert(context, '알림', '이메일 주소를 입력해주세요.');
    }
    else if (emailController.text.contains('@') == false || emailController.text.contains('.com') == false) {
      alert(context, '알림', '제대로된 이메일 주소를 입력해주세요.');
    }
    else if (passwordController.text == '') {
      alert(context, '알림', '비밀번호를 입력해주세요.');
    }
    else if (passwordController.text.length < 6) {
      alert(context, '알림', '비밀번호를 6자 이상 입력해주세요.');
    }
    else if (passwordCheckController.text == '') {
      alert(context, '알림', '비밀번호 확인을 입력해주세요.');
    }
    else if (passwordController.text != passwordCheckController.text) {
      alert(context, '알림', '동일한 비밀번호를 입력해주세요.');
    }
    else if (nicknameController.text == '') {
      alert(context, '알림', '닉네임을 입력해주세요.');
    }
    else {
      setState(() {
        _loading = true;
      });
      bool result = await fp.signUpWithEmail(emailController.text, passwordController.text, passwordCheckController.text, nicknameController.text);
      setState(() {
        _loading = false;
      });
      if (result) {
        Navigator.pop(context);
      } else {
        alert(context, '회원가입 실패', '회원가입에 실패하였습니다. 다시 시도해주시기 바랍니다.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('회원가입'),
        ),
        body: _loading ? circularProgress() : _buildBody(fp)
    );
  }
}
