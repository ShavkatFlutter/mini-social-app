import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasefirstexample/auth/authpage.dart';
import 'package:firebasefirstexample/pages/homepage.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return HomePage();
          }
          else {
            return AuthPage();
          }
        }
      ),
    );
  }
}
