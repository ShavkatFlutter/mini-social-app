import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasefirstexample/pages/homepage.dart';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.blue),
              title: Text("Home"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text("Profile"),
            ),
            ListTile(
              leading: Icon(Icons.bookmark, color: Colors.blue),
              title: Text("Saved content"),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Log out"),
              onTap: (){
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
