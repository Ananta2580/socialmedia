import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/firebase_options.dart';
import 'package:socialmedia/providers/user_provider.dart';
import 'package:socialmedia/responsiveScreenLayout/mobileScreen.dart';
import 'package:socialmedia/responsiveScreenLayout/responsiveScreen.dart';
import 'package:socialmedia/responsiveScreenLayout/webScreen.dart';
import 'package:socialmedia/screens/login_Page.dart';
import 'package:socialmedia/utility/colors.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackGroundColor),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.active){
                if(snapshot.hasData){
                  return const ResponsiveScreen(
                      webScreenLayout: webScreenLayout(),
                      mobileScreenLayout: mobileScreenLayout()
                  );
                }
                else if(snapshot.hasError){
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                }
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const LoginPage();
            }
        ),
      ),
    );
  }
}
