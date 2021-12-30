// models
import 'package:chatting_app/models/firebase_provider.dart';
// screens
import 'package:chatting_app/screens/signup.dart';
// widgets
import 'package:chatting_app/widgets/alert.dart';
import 'package:chatting_app/widgets/progress.dart';
// pakages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  _buildBody(FirebaseProvider fp) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 이메일
              TextFormField(
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: '이메일',
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 14),
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  border: InputBorder.none,
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
              // 비밀번호
              TextFormField(
                // style: TextStyle(color: Colors.white, fontSize: 14),
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
                onFieldSubmitted: (_) => _signIn(fp),
              ),
              SizedBox(height: 10,),
              // 로그인 버튼
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
                    '로그인',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode()); // 키보드 감춤
                    _signIn(fp);
                  },
                ),
              ),
              SizedBox(height: 10,),
              // 회원가입, 아이디 & 비밀번호 찾기
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 회원가입
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp())
                      );
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 아이디 찾기
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '아이디 찾기',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11
                          ),
                        ),
                      ),
                      // DIVIDER
                      Container(
                        width: 0.5,
                        height: 10,
                        color: Colors.white,
                      ),
                      // 비밀번호 찾기
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          '비밀번호 찾기',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              // SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn(FirebaseProvider fp) async {
    if (emailController.text == '') {
      alert(context, '로그인 실패', '로그인 실패하였습니다. 이메일 주소를 입력해주시기 바랍니다.');
    }
    else if (passwordController.text == '') {
      alert(context, '로그인 실패', '로그인 실패하였습니다. 비밀번호를 입력해주시기 바랍니다.');
    }
    else {
      setState(() {
        _loading = true;
      });
      bool result = await fp.signInWithEmail(emailController.text, passwordController.text);
      setState(() {
        _loading = false;
      });
      if (result) {
        // Navigator.pop(context);
      } else {
        alert(context, '로그인 실패', '로그인 실패하였습니다. 다시 시도해주시기 바랍니다.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseProvider fp = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: _loading ? circularProgress() : _buildBody(fp),
    );
  }
}
