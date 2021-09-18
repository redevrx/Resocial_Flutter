import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

import 'localizations/languages.dart';

// import 'package:workmanager/workmanager.dart';
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp().whenComplete(() {
    if (message.notification.title == "chat") {
      // showNotify.showNotifyMessage(message.notification);
    } else {
      //post notify
      // showNotify.showNotifyPost(message.notification);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //this event will wok close app
  await Firebase.initializeApp().whenComplete(() async {
    final notifyService = new PushNotificationService();
    print('Firebase Initial Complete');
    await notifyService.initialise();
    notifyService.getDeviceToken();
  });
  //
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  // notifyService.initBackground();

  if (kIsWeb) {
    // Disable persistence on web platforms
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  if (userFirestoreEmulator) {
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  }

  // Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

bool userFirestoreEmulator = false;

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale) {
    final state = context.findAncestorStateOfType<_MyAppState>();

    state.changeLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void changeLocale(Locale locale) {
    setState(() {
      this._locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final languageApp = AppLocalizations(null);
    final localeKey = await languageApp.readLocaleKey();

    if (localeKey == "en") {
      this._locale = new Locale("en", "EN");
    } else {
      this._locale = new Locale("th", "TH");
    }
  }

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
          // "/requestFriend":(context) => RequestFriend,
        },
        //debugShowCheckedModeBanner: false,
        title: "Social App",
        locale: _locale,
        supportedLocales: [
          Locale('en', 'EN'),
          Locale('th', 'TH'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocaleLanguage in supportedLocales) {
            if (supportedLocaleLanguage?.languageCode == locale?.languageCode &&
                supportedLocaleLanguage?.countryCode == locale?.countryCode) {
              return supportedLocaleLanguage;
            }
          }

          // If device not support with locale to get language code then default get first on from the list
          return supportedLocales?.first;
        },
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
