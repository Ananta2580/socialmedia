
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:socialmedia/screens/addPost_screen.dart';
import 'package:socialmedia/screens/favorite_screen.dart';
import 'package:socialmedia/screens/feed_screen.dart';
import 'package:socialmedia/screens/profile_screen.dart';
import 'package:socialmedia/screens/search_screen.dart';
import 'package:socialmedia/utility/colors.dart';

class mobileScreenLayout extends StatefulWidget {
  const mobileScreenLayout({super.key});

  @override
  State<mobileScreenLayout> createState() => _mobileScreenLayoutState();
}

class _mobileScreenLayoutState extends State<mobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  void OnPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  final screenList = [
    FeedScreen(),
    SearchScreen(),
    AddPostScreen(),
    FavoriteScreen(),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
        children: screenList,
        controller: pageController,
        onPageChanged: OnPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,color: (_page == 0) ? whiteColor : greyColor,),
              label: "",
              backgroundColor: mobileBackGroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search,color: (_page == 1) ? whiteColor : greyColor,),
              label: "",
              backgroundColor: mobileBackGroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle,color: (_page == 2) ? whiteColor : greyColor,),
              label: "",
              backgroundColor: mobileBackGroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite,color: (_page == 3) ? whiteColor : greyColor,),
              label: "",
              backgroundColor: mobileBackGroundColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,color: (_page == 4) ? whiteColor : greyColor,),
              label: "",
              backgroundColor: mobileBackGroundColor,
            ),
          ],
          onTap: navigationTapped,
      ),
    );
  }
}
