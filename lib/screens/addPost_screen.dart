import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/firebase_resources/firestore_methods.dart';
import 'package:socialmedia/models/user.dart';
import 'package:socialmedia/providers/user_provider.dart';
import 'package:socialmedia/utility/colors.dart';
import 'package:socialmedia/utility/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  TextEditingController captionController = TextEditingController();
  Uint8List? _file;
  bool isLoading = false;

  void selectImage(BuildContext parentContext) async{

    return showDialog(
        context: parentContext,
        builder: (BuildContext context){
          return SimpleDialog(
            title: const Text("Create a post"),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20.0),
                child: const Text("Take a Photo"),
                onPressed: () async{
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20.0),
                child: const Text("Choose from Gallery"),
                onPressed: () async{
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20.0),
                child: const Text("Cancel"),
                onPressed: () async{
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  void postImage(String uid,String username,String image) async{
    setState(() {
      isLoading = true;
    });
    try{
      String result = await FirestoreMethods().uploadPost(_file!, captionController.text, username, image, uid);

      if(result == "Success"){
        setState(() {
          isLoading = false;
        });
        VxToast.show(context, msg: "Posted Successfully");
        clearImage();
      }
      else{
        setState(() {
          isLoading = false;
        });
        VxToast.show(context, msg: result);
      }
    }catch(e){
      VxToast.show(context, msg: e.toString());
    }
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final USER user = Provider.of<UserProvider>(context).getUser;

    return _file == null ? Center(
        child: ElevatedButton(
            onPressed: () => selectImage(context),
            child: Icon(Icons.upload)
        ),
    )


    : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackGroundColor,
        leading: IconButton(onPressed: clearImage, icon: Icon(Icons.arrow_back)),
        title: const Text("Post To"),
        actions: [
          TextButton(
              onPressed: () => postImage(
                user.uid,user.username,user.photoUrl
              ),
              child: const Text("Post",style: TextStyle(color: blueColor,fontSize: 20,fontWeight: FontWeight.bold),))
        ],
      ),
      body: Column(
        children: [
          isLoading ? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0.0)),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.3,
                child: TextField(
                  controller: captionController,
                  decoration: InputDecoration(
                    hintText: "Write Caption...",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45.0,
                width: 45.0,
                child: AspectRatio(
                  aspectRatio: 487/451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter
                      )
                    ),
                  ),
                ),
              ),
              const Divider()
            ],
          )
        ],
      ),
    );
  }
}
