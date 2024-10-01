import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/providers/user_provider.dart';
import 'package:socialmedia/utility/dimensions.dart';

class ResponsiveScreen extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveScreen({super.key,required this.webScreenLayout,required this.mobileScreenLayout});

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async{
    UserProvider _userprovider = Provider.of(context,listen: false);
    await _userprovider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context,constraints){
          if(constraints.maxWidth > webScreenSize){
            //webScreen
            return widget.webScreenLayout;
          }
          //mobileScreen
          return widget.mobileScreenLayout;
        }
    );
  }
}
