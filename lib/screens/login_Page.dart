import 'package:flutter/material.dart';
import 'package:socialmedia/firebase_resources/firebase_auth_services.dart';
import 'package:socialmedia/responsiveScreenLayout/mobileScreen.dart';
import 'package:socialmedia/responsiveScreenLayout/responsiveScreen.dart';
import 'package:socialmedia/responsiveScreenLayout/webScreen.dart';
import 'package:socialmedia/screens/signUp_Page.dart';
import 'package:socialmedia/utility/colors.dart';
import 'package:socialmedia/utility/dimensions.dart';
import 'package:socialmedia/widgets/input_TextField.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String result = await AuthServices().SignIn_user(
        email: emailController.text, password: passwordController.text);

    setState(() {
      isLoading = false;
    });

    if (result == 'Success') {
      VxToast.show(
        context,
        msg: result,
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveScreen(
              webScreenLayout: webScreenLayout(),
              mobileScreenLayout: mobileScreenLayout()
          )
      )
      );
    } else {
      VxToast.show(context, msg: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
              child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize ?
            EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3):
            const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Link_UpM",
                  style: TextStyle(
                      fontFamily: "logo", fontSize: 34, color: whiteColor),
                ),
                SizedBox(
                  height: 40,
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
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(blueColor)),
                      onPressed: loginUser,
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const Text("LogIn")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an Account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => SignUpPage()));
                        },
                        child: Text("SignUp Here"))
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
