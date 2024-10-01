
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:socialmedia/firebase_resources/firebase_storage_services.dart';
import 'package:socialmedia/models/posts.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    Uint8List file,
    String description,
    String username,
    String profImg,
    String uid,
  ) async {
    String result = "Some Error occurred";
    try {
      String photoUrl =
          await StorageServices().uploadImgToStorage('posts', file, true);

      String postId = const Uuid().v1();

      POST post = POST(
          caption: description,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profImage: profImg
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());
      result = "Success";
    } catch (err) {
      result = err.toString();
    }
    return result;
  }

  Future<void> likePost(String postId, String uId, List likes) async{
    try{
      if(likes.contains(uId)){
        await _firestore.collection('posts').doc(postId).update({
          'likes' : FieldValue.arrayRemove([uId])
        });
      }
      else{
        await _firestore.collection('posts').doc(postId).update({
          'likes' : FieldValue.arrayUnion([uId])
        });
      }
    }catch(err){
      print(err.toString());
    }
  }

  Future<void> postComment(String name, String postId, String uId, String text, String profilePic) async{
    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set(
            {
              'profilePic' : profilePic,
              'name' : name,
              'Uid' : uId,
              'text' : text,
              'commentId' : commentId,
              'datePublished' : DateTime.now(),
            });
      }
      else{
        print("Text is Empty");
      }
    }catch(err){
      print(err.toString());
    }
  }

  Future<void> deletePost(String postId) async{
    try{
      await _firestore.collection('posts').doc(postId).delete();
    }catch(err){
      print(err.toString());
    }
  }


  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
      await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }


}
