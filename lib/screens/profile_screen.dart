import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/firebase_resources/firebase_auth_services.dart';
import 'package:socialmedia/firebase_resources/firestore_methods.dart';
import 'package:socialmedia/screens/login_Page.dart';
import 'package:socialmedia/utility/colors.dart';
import 'package:socialmedia/widgets/follow_Button.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async{
    setState(() {
      isLoading = true;
    });
    try{
      var userSnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('Uid',isEqualTo: widget.uid)
          .get();
      userData = userSnap.data()!;
      postLen = postSnap.docs.length;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {

      });
    }catch(err){
      VxToast.show(context, msg: err.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: CircularProgressIndicator(),) : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackGroundColor,
        title: Text("Profile"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(userData['photoUrl']),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postLen, "Posts"),
                              buildStatColumn(followers, "Followers"),
                              buildStatColumn(following, "Following"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FirebaseAuth.instance.currentUser!.uid == widget.uid ? FollowButton(
                                  backgroundColor: mobileBackGroundColor,
                                  borderColor: greyColor,
                                  text: "SignOut",
                                  textColor: whiteColor,
                                function: () async{
                                    await AuthServices().signOut();
                                    Navigator
                                        .of(context)
                                        .pushReplacement(MaterialPageRoute(builder: (context) =>
                                    const LoginPage()));
                                },
                              ) : isFollowing ? FollowButton(
                                  backgroundColor: Colors.white,
                                  borderColor: greyColor,
                                  text: "Unfollow",
                                  textColor: Colors.black,
                                function: () async{
                                    await FirestoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid, userData['Uid']
                                    );
                                    setState(() {
                                      isFollowing = false;
                                      followers--;
                                    });
                                },
                              ) : FollowButton(
                                  backgroundColor: blueColor,
                                  borderColor: greyColor,
                                  text: "Follow",
                                  textColor: whiteColor,
                                function: () async{
                                    await FirestoreMethods().followUser(
                                        FirebaseAuth.instance.currentUser!.uid, userData['Uid']
                                    );
                                    setState(() {
                                      isFollowing = true;
                                      followers++;
                                    });
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    userData['userName'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 1),
                  child: Text(
                    userData['bio'],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').where('Uid',isEqualTo: widget.uid).get(),
              builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 1
                    ),
                    itemBuilder: (context,index){
                    DocumentSnapshot snap = snapshot.data!.docs[index];
                    
                    return Container(
                      child: Image(
                        image: NetworkImage(snap['postUrl']),
                      ),
                    );
                    }
                );

              }
          )
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
