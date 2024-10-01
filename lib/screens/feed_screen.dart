import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/screens/message_screen.dart';
import 'package:socialmedia/utility/colors.dart';
import 'package:socialmedia/widgets/postcard.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackGroundColor,
        title: const Text("LinkUpM",style: TextStyle(color: whiteColor,fontFamily: "logo"),),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => MessageScreen()));
          },
              icon: const Icon(Icons.message))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').orderBy('datePublished',descending: true).snapshots(),
          builder: (context , AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => PostCard(
                  snap: snapshot.data!.docs[index].data(),
                )
            );
          }
      ),
    );
  }
}
