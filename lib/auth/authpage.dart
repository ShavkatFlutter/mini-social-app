import 'package:firebasefirstexample/pages/loginpage.dart';
import 'package:firebasefirstexample/pages/regesterPage.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override

  bool showLoginPage =true;

  void toggleScreens (){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(showRegisterPage: toggleScreens);
    }
    else {
      return RegisterPage(showLoginPage: toggleScreens);
    }
  }
}
