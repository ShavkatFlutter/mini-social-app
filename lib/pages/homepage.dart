import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Asosiy sahifa"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text("Signed in as: " + "${user.email!}", style: TextStyle(fontWeight: FontWeight.bold),),
          ),
          MaterialButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
              },
              color: Colors.red,
            child: Text("Log out", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
