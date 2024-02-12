import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasefirstexample/buttons/delete_comment.dart';
import 'package:flutter/material.dart';

import '../pages/delete.dart';

class Comment extends StatefulWidget {
  final String text;
  final String user;
  final String time;
  final String postId;
  final String comId;
  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
    required this.postId,
    required this.comId,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override

  final currentUser = FirebaseAuth.instance.currentUser!;

  void deleteComment() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Delete post."),
          content: Text("Are you sure to delete this post?"),
          actions: [
            //Cancel button
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            //Delete button
            TextButton(
              onPressed: () async {
                final commentDocs = await FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .doc(widget.comId)
                    .delete()
                    .then((value) => Navigator.pop(context))
                    .catchError((error) => print("failed to delete post"));
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ));
  }


  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(widget.user, style: TextStyle(color: Colors.grey[800]),),
              if (widget.user == currentUser.email)
                DeleteComment(onTap: deleteComment),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(widget.text, style: TextStyle(fontSize: 17),),
                ],
              ),
              Text(widget.time),
            ],
          ),
        ],
      ),
    );
  }
}
