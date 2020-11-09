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
import 'package:socialapp/home/bloc/state_pageChange.dart';
import 'package:socialapp/home/screen/home_page.dart';
import 'package:socialapp/home/bloc/bloc_pageChange.dart';
import 'package:socialapp/notifications/exportNotify.dart';
import 'package:socialapp/userPost/export/export_new_post.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() async {
    print('Firebase Initial Complete');
    final notifyService = PushNotificationService();
    await notifyService.initialise();
    notifyService.getDeviceToken();
  });
  if (kIsWeb) {
    // Disable persistence on web platforms
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  }

  // Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

bool USE_FIRESTORE_EMULATOR = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // _initialBackgound();
    return BlocProvider(
      create: (context) =>
          PageNaviagtorChageBloc(onPageChangeState(pageNumber: 0)),
      child: MaterialApp(
        routes: {
          "/": (context) => HomePage(),
          "/home": (context) => HomePage(),
          "/login": (context) => LoginScreen(),
          "/signUp": (context) => SignUpScreen(),
          "/addProfile": (context) => AddProfile(),
          "/userProfile": (context) => UserProfile(),
          "/newPost": (context) => CreatePost(),
        },
        //debugShowCheckedModeBanner: false,
        title: "Social App",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}

// void _initialBackgound() {
//   if (Platform.isIOS) {
//     // ios setting task
//   } else {
//     // android setting task
//     Workmanager.initialize(_callbackDispatcher, isInDebugMode: true);
//     Workmanager.registerPeriodicTask("6", "onLoadFeed",
//         frequency: Duration(minutes: 15));
//   }
// }

// void _callbackDispatcher() {
//   Workmanager.executeTask((taskName, inputData) async {
//     print('start service load user feed ');
//     // final feed = new FeedRepository();
//     // await feed.getFeed();
//     return Future.value(true);
//   });
// }

// void _settingloadFeed(MyFeedBloc myFeedBloc, LikeBloc likeBloc) async {
//   //event load my feed
//   myFeedBloc.add(onLoadMyFeedClick());
//   likeBloc.add(onLikeResultPostClick());
// }
