import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/Login/screen/login_page.dart';
import 'package:socialapp/Login/screen/register_user.dart';
import 'package:socialapp/Profile/AddProfile/screen/add_info_profile.dart';
import 'package:socialapp/Profile/EditPtofile/screen/user_profile.dart';
import 'package:socialapp/home/screen/home_page.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kIsWeb) {
    // Disable persistence on web platforms
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
    // final user = await FirebaseAuth.instance.currentUser;
    // // final user = auth.currentUser;
    // if (user != null) {
    //   // Navigator.of(context).push(MaterialPageRoute(
    //   //   builder: (context) => HomePage(),
    //   // ));
    //   print("Login ..." + user.uid);
    // } else {
    //   print("yet Login.." + user.uid);
    // }
  }
  runApp(MyApp());
}

bool USE_FIRESTORE_EMULATOR = false;

class MyApp extends StatelessWidget {
  // Future<void> getInitailFirebaseOffnlie() async {
  //   await Firebase.initializeApp();
  //   if (USE_FIRESTORE_EMULATOR) {
  //     FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // getInitailFirebaseOffnlie();
    return MaterialApp(
      routes: {
        "/": (context) => LoginScreen(),
        "/signUp": (context) => SignUpScreen(),
        "/home": (context) => HomePage(),
        "/addProfile": (context) => AddProfile(),
        "/userProfile": (context) => UserProfile(),
        "/newPost": (context) => CreatePost(),
      },
      //debugShowCheckedModeBanner: false,
      title: "Social App",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
