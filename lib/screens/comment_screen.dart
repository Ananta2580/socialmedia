import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/firebase_resources/firestore_methods.dart';
import 'package:socialmedia/models/user.dart';
import 'package:socialmedia/providers/user_provider.dart';
import 'package:socialmedia/utility/colors.dart';
import 'package:socialmedia/widgets/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({Key? key,required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final USER user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackGroundColor,
        title: const Text("Comments"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.photoUrl),
                  radius: 18,
                ),
                // SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16,right: 8),
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () async{
                      await FirestoreMethods().postComment(
                          user.username,
                          widget.snap['postId'],
                          user.uid,
                          commentController.text,
                          user.photoUrl
                      );
                    },
                    icon: const Icon(Icons.send_outlined,color: blueColor,)
                )
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.
          collection('posts').
          doc(widget.snap['postId']).
          collection('comments').
          orderBy('datePublished',descending: true).
          snapshots(),

          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                return CommentCard(
                  snap: snapshot.data!.docs[index].data(),
                );
                }
            );
          }
      ),
    );
  }
}
