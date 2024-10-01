import 'package:cloud_firestore/cloud_firestore.dart';

class POST{
  final String caption;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;


  const POST({
    required this.caption,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
  });

  Map<String,dynamic> toJson() => {
    'caption' : caption,
    'Uid' : uid,
    'username' : username,
    'likes' : likes,
    'postId' : postId,
    'datePublished' : datePublished,
    'postUrl' : postUrl,
    'profImage' : profImage,
  };

  static POST fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return POST(
        caption: snapshot['caption'],
        uid: snapshot['Uid'],
        username: snapshot['username'],
        likes: snapshot['likes'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage']
    );
  }
}