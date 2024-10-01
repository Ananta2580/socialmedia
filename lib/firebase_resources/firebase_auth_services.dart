import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/models/user.dart';
import 'package:socialmedia/firebase_resources/firebase_storage_services.dart';

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<USER> getUserDetails() async{
    User currentuser = firebaseAuth.currentUser!;

    DocumentSnapshot snap = await firestore.collection('users').doc(currentuser.uid).get();

    return USER.fromSnap(snap);
  }

  // Signup method
  Future<String> Signup_user({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String result = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        //register User
        UserCredential credential = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        String photoUrl = await StorageServices()
            .uploadImgToStorage('profilePics', file, false);

        // add user to firebase

        USER user = USER(
            email: email,
            password: password,
            uid: credential.user!.uid,
            photoUrl: photoUrl,
            username: username,
            bio: bio,
            followers: [],
            following: []);

        await firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());

        result = "Success";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        result = "Email is badly formatted";
      } else if (error.code == 'weak-password') {
        result = " Enter at least 6 characters";
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  // Login method

  Future<String> SignIn_user({
    required String email,
    required String password,
  }) async {
    String result = "Some Error in login";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //login user
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        result = "Success";
      } else {
        result = "Enter all the fields";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        result = "Email is badly formatted";
      } else if (error.code == 'weak-password') {
        result = " Enter at least 6 characters";
      }
    } catch (error) {
      result = error.toString();
    }
    return result;
  }

  Future<void> signOut() async{
    await firebaseAuth.signOut();
  }

}
