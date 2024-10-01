import 'package:flutter/material.dart';
import 'package:socialmedia/firebase_resources/firebase_auth_services.dart';
import 'package:socialmedia/models/user.dart';

class UserProvider with ChangeNotifier{
  USER? _user;
  final AuthServices _authServices = AuthServices();

  USER get getUser {
    if (_user != null) {
      return _user!;
    } else {
      // Return a default USER object or handle the null case as per your requirement
      return USER(
        email: '',
        password: '',
        uid: '',
        photoUrl: '',
        username: '',
        bio: '',
        followers: [],
        following: [],
      );
    }
  }


  Future<void> refreshUser() async{
    USER user = await _authServices.getUserDetails();
    _user = user;
    notifyListeners();
  }
}