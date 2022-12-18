import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  bool alreadySignedUp = false;

  void handleSignUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailEditingController.text,
          password: passwordEditingController.text,
      );
    } on FirebaseAuthException catch(e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('既に使用されているメールアドレスです'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('パスワードは6文字以上に設定してください'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('メールアドレスの形式が正しくありません'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  void handleSignIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailEditingController.text,
          password: passwordEditingController.text,
      );
    } on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('登録されていないメールアドレスです'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('パスワードが正しくありません'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('メールアドレスの形式が正しくありません'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width/2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailEditingController,
              decoration: InputDecoration(
                  labelText: 'メールアドレス',
                  border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: passwordEditingController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'パスワード',
                  border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20,),
            alreadySignedUp?ElevatedButton(
              onPressed: () {
                handleSignIn();
              },
              child: Text('サインイン', style: TextStyle(color: Colors.white),),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              ),
            ):ElevatedButton(
              onPressed: () {
                handleSignUp();
              },
              child: Text('ユーザー登録', style: TextStyle(color: Colors.white),),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              ),
            ),
            SizedBox(height: 20,),
            TextButton(
              onPressed: () {
                setState(() {
                  alreadySignedUp = !alreadySignedUp;
                });
              },
              child: Text(
                alreadySignedUp?'アカウントを作成':'既にアカウントをお持ちですか？',
                style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline),
              )
            ),
          ],
        ),
      ),
    );
  }
}
