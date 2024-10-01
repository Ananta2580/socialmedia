import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:socialmedia/screens/profile_screen.dart';
import 'package:socialmedia/utility/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchController = TextEditingController();
  bool isShowing = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackGroundColor,
          title: SizedBox(
            height: 50,
            child: TextFormField(
              controller: searchController,
              onFieldSubmitted: (String _){
                setState(() {
                  isShowing = true;
                });
              },
              decoration: InputDecoration(
                  hintText: "Search for a user...",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search)
              ),
            ),
          ),
        ),
        body: isShowing ? FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('users')
                .where('userName',isGreaterThanOrEqualTo: searchController.text.toUpperCase())
                .get(),
            builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
              if(!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final userData = snapshot.data!.docs[index].data(); // Access user data

                  // Check if 'userName' exists and is not null
                  if (userData.containsKey('userName') && userData['userName'] != null) {
                    // Construct the leading widget based on the availability of 'photoUrl'
                    final photoUrl = userData.containsKey('photoUrl') ? userData['photoUrl'] : null;
                    final leadingWidget = photoUrl != null
                        ? CircleAvatar(
                      backgroundImage: NetworkImage(photoUrl),
                    )
                        : CircleAvatar(); // Use a default avatar if 'photoUrl' is null

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(uid: snapshot.data!.docs[index]['Uid'])));
                      },
                      child: ListTile(
                        title: Text(userData['userName']),
                        leading: leadingWidget,
                      ),
                    );
                  } else {
                    // Return an empty container if 'userName' is null or not found
                    return Container();
                  }
                },
              );



            }
        ) : FutureBuilder(
            future: FirebaseFirestore.instance.collection('posts').get(),
            builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
              if(!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: MasonryGridView.count(
                    crossAxisCount: 3,
                    itemCount: snapshot.data!.docs.length,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    itemBuilder: (context,index){
                      return Image.network(snapshot.data!.docs[index]['postUrl'],fit: BoxFit.cover,);
                    }
                ),
              );

            }
        )
    );
  }
}