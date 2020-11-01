import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final showNotify = ShowNotifyService();

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
    print("onBackgriundMessage");
  }

  Future initialise() {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
      _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }

    //create notify ios and android
    showNotify.initialNotify();

    _fcm.configure(
      // onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (message) {
        print("onMessage: $message");
        //post notidy
        showNotify.showNotifyPost(message);
      },
      // onBackgroundMessage:
      //     TargetPlatform.iOS == 'ios' ? null : myBackgroundMessageHandler,
      // onLaunch: (Map<String, dynamic> message) async {
      //   print("onLaunch: $message");
      // },
      // onBackgroundMessage : myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onBackgriundMessage: $message");
        showNotify.showNotifyPost(message);
      },
      onResume: (message) {
        print("onResume: $message");
      },
    );
  }

  getDeviceToken() async {
    return await _fcm.getToken().then((token) {
      assert(token != null);
      saveTokenUser(token);
      print('my Device TOken : ' + token);
      return token;
    });
  }

  Future onSubscribe(String topic) {
    _fcm.subscribeToTopic(topic);
  }

  Future unSubscribe(String topic) {
    _fcm.unsubscribeFromTopic(topic);
  }

  Future<void> saveTokenUser(String token) async {
    final _mRef = FirebaseFirestore.instance;
    final _mAuth = FirebaseAuth.instance;

    //shared preference
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    final pref = await _pref;

    //get uid your current user
    _mAuth.authStateChanges().listen((user) {
      // print(user.uid);
      pref.setString("uid", user.uid);
      _mRef
          .collection("user info")
          .doc(user.uid)
          .update({'deviceToken': '${token}'})
          .then((value) => print("save device token success"))
          .catchError((e) => print(e));
    });
  }
}

class ShowNotifyService {
  FlutterLocalNotificationsPlugin flutterNotify =
      FlutterLocalNotificationsPlugin();

  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  Future initialNotify() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings("launch_background");

    var initializationSettingsIos = IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
        //ios click notify
        print("onDidReceiveLocalNotification called.");
      },
    );

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIos);

    flutterNotify.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        // when user tap on notification.
        print("onSelectNotification called.");
      },
    );
  }

  showNotifyPost(Map<String, dynamic> message) async {
    //create android ip channel description channel
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "notify_post",
      "post",
      "show notify to friends",
      importance: Importance.Max,
      priority: Priority.High,
    );

    //create ios setting notify
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    //create platform ios android noify
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    //show notify
    //id notify_post 1
    await flutterNotify.show(1, "" + message["notification"]['title'],
        message["notification"]['body'], platformChannelSpecifics,
        payload: 'FLUTTER_NOTIFICATION_CLICK');
  }
}
