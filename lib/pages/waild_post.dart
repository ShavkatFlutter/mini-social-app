import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasefirstexample/buttons/comment.dart';
import 'package:firebasefirstexample/buttons/commentButton.dart';
import 'package:firebasefirstexample/buttons/like_button.dart';
import 'package:firebasefirstexample/helper/helper_method.dart';
import 'package:firebasefirstexample/pages/delete.dart';
import 'package:flutter/material.dart';

class WaildPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  final time;

  const WaildPost({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  }) : super(key: key);

  @override
  State<WaildPost> createState() => _WaildPostState();
}

class _WaildPostState extends State<WaildPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
    FirebaseFirestore.instance.collection("User Posts").doc(widget.postId);

    if (isLiked) {
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email]),
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now(),
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(
            hintText: "Write a comment...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);

              _commentTextController.clear();

              Navigator.pop(context);
            },
            child: Text(
              "Post reply",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  void deletePost() {
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
                  .get();

              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .doc(doc.id)
                    .delete();
              }

              FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 15,
            offset: Offset(5, 5),
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 15,
            offset: Offset(-5, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
            ),
            padding: EdgeInsets.all(8),
            child: GestureDetector(
              child: Icon(Icons.person, size: 20),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              //Message bar, posts
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.user,
                      style: TextStyle(fontSize: 17),
                    ),
                    if (widget.user == currentUser.email)
                      IconButton(
                        icon: Icon(Icons.cancel_outlined, color: Colors.red[300]),
                        onPressed: deletePost,
                      ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  widget.message,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 15),
                Text(widget.time, style: TextStyle(color: Colors.grey)),
                SizedBox(height: 15),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("User Posts")
                      .doc(widget.postId)
                      .collection("Comments")
                      .orderBy("CommentTime", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map((doc) {
                        final commentData =
                        doc.data() as Map<String, dynamic>;

                        return Comment(
                          text: commentData["CommentText"],
                          user: commentData["CommentedBy"],
                          time: formatData(commentData["CommentTime"]),
                          postId: widget.postId,
                          comId: doc.id,
                        );
                      }).toList(),
                    );
                  },
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CommentButton(onTap: showCommentDialog),
                          SizedBox(width: 5),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("User Posts")
                                .doc(widget.postId)
                                .collection("Comments")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text("0");
                              }
                              return Text(
                                  snapshot.data!.docs.length.toString());
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          LikeButton(
                            isLiked: isLiked,
                            onTap: toggleLike,
                          ),
                          SizedBox(width: 5),
                          Text(widget.likes.length.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
