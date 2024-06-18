import 'package:d0_an_co_so/Jobs/jobs_screen.dart';
import 'package:d0_an_co_so/LoginPage/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatefulWidget {
  @override
  State<UserState> createState() => _UserStateState();
}

class _UserStateState extends State<UserState> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshort){
          if(userSnapshort.data == null){
            print('Người dùng chưa được đăng nhập');
            return Login();
          }
          else if(userSnapshort.hasData){
            print('Người dùng đã đăng nhập');
            return JobScreen();
          }

          else if(userSnapshort.hasError){
            return const Scaffold(
              body: Center(
                child: Text('Một lỗi đã được phát hiện, Thử lại sau'),
              ),
            );
          }

          else if(userSnapshort.connectionState == ConnectionState.waiting){
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text('Có gì đó không đúng'),
            ),
          );
        }
    );
  }
}
