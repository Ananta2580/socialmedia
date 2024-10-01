import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialmedia/firebase_resources/firebase_auth_services.dart';
import 'package:socialmedia/responsiveScreenLayout/mobileScreen.dart';
import 'package:socialmedia/responsiveScreenLayout/responsiveScreen.dart';
import 'package:socialmedia/responsiveScreenLayout/webScreen.dart';
import 'package:socialmedia/screens/login_Page.dart';
import 'package:socialmedia/utility/colors.dart';
import 'package:socialmedia/utility/utils.dart';
import 'package:socialmedia/widgets/input_TextField.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  Uint8List? image;
  bool isLoading = false;
  AuthServices authServices = AuthServices();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    bioController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  void signupUser() async{
    setState(() {
      isLoading = true;
    });
    String result = await authServices.Signup_user(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text,
        bio: bioController.text,
        file: image!
    );
    setState(() {
      isLoading = false;
    });
    if(result != 'Success'){
      VxToast.show(context, msg: result,);
    }else{
      VxToast.show(context, msg: result);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveScreen(
              webScreenLayout: webScreenLayout(),
              mobileScreenLayout: mobileScreenLayout()
          )
      )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Link_UpM",
                  style: TextStyle(
                      fontFamily: "logo", fontSize: 34, color: whiteColor),
                ),
                SizedBox(
                  height: 40,
                ),
                Stack(
                  children: [
                    image != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: MemoryImage(image!)
                                )
                        : const CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage("assets/image/profile.jpeg")),
                    Positioned(
                        bottom: -10,
                        left: 70,
                        child: IconButton(
                            onPressed: selectImage,
                            icon: Icon(Icons.add_a_photo)))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                InputTextField(
                    textEditingController: usernameController,
                    textInputType: TextInputType.text,
                    hintText: "Username",
                    isPassword: false),
                const SizedBox(
                  height: 10,
                ),
                InputTextField(
                    textEditingController: emailController,
                    textInputType: TextInputType.emailAddress,
                    hintText: "Enter Mail",
                    isPassword: false),
                SizedBox(
                  height: 10,
                ),
                InputTextField(
                    textEditingController: passwordController,
                    textInputType: TextInputType.text,
                    hintText: "Enter Password",
                    isPassword: true),
                SizedBox(
                  height: 10,
                ),
                InputTextField(
                    textEditingController: bioController,
                    textInputType: TextInputType.text,
                    hintText: "Enter Bio",
                    isPassword: false),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(blueColor)),
                      onPressed: signupUser,
                      child: isLoading ? const Center(child: CircularProgressIndicator(),) : const Text("SignUp")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an Account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => LoginPage()));
                        },
                        child: Text("SignIn Here"))
                  ],
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
