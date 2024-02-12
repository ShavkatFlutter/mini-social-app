import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasefirstexample/helper/helper_method.dart';
import 'package:firebasefirstexample/pages/sidebar.dart';
import 'package:firebasefirstexample/pages/waild_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        "UserEmail": currentUser.email,
        "Message": textController.text,
        "TimeStamp": Timestamp.now(),
        "Likes": [],
      });
    }
    setState(() {
      textController.clear();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close keyboard when the screen is tapped
        _focusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        drawer: SideBar(),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Asosiy sahifa"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("User Posts")
                      .orderBy(
                    "TimeStamp",
                    descending: false,
                  )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return WaildPost(
                            message: post["Message"],
                            user: post["UserEmail"],
                            postId: post.id,
                            likes: List<String>.from(post["Likes"] ?? []),
                            time: formatData(post["TimeStamp"]),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, bottom: 30),
                      child: GestureDetector(
                        onTap: () {
                          // Empty onTap handler to prevent tap propagation
                        },
                        child: TextField(
                          focusNode: _focusNode,
                          controller: textController,
                          onEditingComplete: () {
                            setState(() {
                              textController.text =
                              '\n${textController.text}';
                            });
                          },
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: "Enter your text here...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: IconButton(
                      onPressed: postMessage,
                      icon: Icon(Icons.send, size: 45, color: Colors.blue),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
