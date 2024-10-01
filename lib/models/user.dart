import 'package:cloud_firestore/cloud_firestore.dart';

class USER{
  final String email;
  final String password;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;


  const USER({
    required this.email,
    required this.password,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
});

  Map<String,dynamic> toJson() => {
    "userName" : username,
    "Uid" : uid,
    "eMail" : email,
    "password" : password,
    "bio" : bio,
    "following" : following,
    "followers" : followers,
    "photoUrl" : photoUrl
  };

  static USER fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return USER(
        email: snapshot['eMail'] ?? '',
        password: snapshot['password'] ?? '',
        uid: snapshot['Uid'] ?? '',
        photoUrl: snapshot['photoUrl'] ?? '',
        username: snapshot['userName'] ?? '',
        bio: snapshot['bio'] ?? '',
        followers: snapshot['followers'] ?? '',
        following: snapshot['following'] ?? ''
    );
  }
}