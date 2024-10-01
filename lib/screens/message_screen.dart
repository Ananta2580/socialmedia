import 'package:flutter/material.dart';
import 'package:socialmedia/utility/colors.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackGroundColor,
        title: const Text("Messages"),
      ),
      body: Center(
        child: Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: 210,
            decoration: BoxDecoration(
                color: Colors.red
            ),
            child: Center(
                child: Text("Coming Soon..",style: TextStyle(fontSize: 30,),)),
          ),
        ),
      ),
    );
  }
}
