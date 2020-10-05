import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/Login/screen/login_page.dart';
import 'package:socialapp/Login/screen/register_user.dart';
import 'package:socialapp/Profile/AddProfile/screen/add_info_profile.dart';
import 'package:socialapp/Profile/EditPtofile/screen/user_profile.dart';
import 'package:socialapp/home/export/export_file.dart';
import 'package:socialapp/home/screen/home_page.dart';
import 'package:socialapp/likes/export/export_like.dart';
import 'package:socialapp/notifications/exportNotify.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:workmanager/workmanager.dart';

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
  final notifyService = PushNotificationService();
  notifyService.initialise();
  notifyService.getDeviceToken();
  runApp(MyApp());
}

bool USE_FIRESTORE_EMULATOR = false;

class MyApp extends StatelessWidget {
  MyFeedBloc myFeedBloc;
  LikeBloc likeBloc;
  @override
  Widget build(BuildContext context) {
    // myFeedBloc = BlocProvider.of<MyFeedBloc>(context);
    // likeBloc = BlocProvider.of<LikeBloc>(context);
    //on work backgroun feed data
    // _settingloadFeed(myFeedBloc, likeBloc);
    // _initialBackgound(myFeedBloc, likeBloc);
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

void _initialBackgound(MyFeedBloc myFeedBloc, LikeBloc likeBloc) {
  if (Platform.isIOS) {
    // ios setting task
  } else {
    // android setting task
  //   Workmanager.initialize(_callbackDispatcher, isInDebugMode: false);
  //   Workmanager.registerPeriodicTask("1", "onLoadFeed",
  //       frequency: Duration(minutes: 15));
   }
}

void _callbackDispatcher(MyFeedBloc myFeedBloc, LikeBloc likeBloc) {
  // Workmanager.executeTask((taskName, inputData) {
  //   _settingloadFeed(myFeedBloc, likeBloc);
  //   return Future.value(true);
  // });
}

void _settingloadFeed(MyFeedBloc myFeedBloc, LikeBloc likeBloc) async {
  //event load my feed
  myFeedBloc.add(onLoadMyFeedClick());
  likeBloc.add(onLikeResultPostClick());
}
