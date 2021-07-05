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
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final showNotify = ShowNotifyService();

  // Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  //   await Firebase.initializeApp().whenComplete(() {
  //     if (message.notification.title == "chat") {
  //       showNotify.showNotifyMessage(message.notification);
  //     } else {
  //       //post notidy
  //       showNotify.showNotifyPost(message.notification);
  //     }
  //   });
  // }
  Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
    await Firebase.initializeApp().whenComplete(() {
      if (message.notification.title == "chat") {
        // showNotify.showNotifyMessage(message.notification);
      } else {
        //post notidy
        // showNotify.showNotifyPost(message.notification);
      }
    });
  }

  void initBackground() {
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }

  Future initialise() async {
    if (Platform.isIOS) {
      //ios request permission about notifications

      await _fcm
          .requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      )
          .then((notification) {
        print(
            'User granted permission IOS : ${notification.authorizationStatus}');
      }).catchError((e) {
        print('User granted permission IOS Error: ${e}');
      });
    }

    //android request permission about notification
    await _fcm
        .requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    )
        .then((notification) {
      print(
          'User granted permission Android : ${notification.authorizationStatus}');
    }).catchError((e) {
      print('User granted permission Android Error: ${e}');
    });

    //create notify ios and android
    showNotify.initialNotify();

    //this event will wok close app
    // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    //this event will work when user click
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification.title == "chat") {
        print("cleck notification open chat screen");
        // showNotify.showNotifyMessage(message.data);
        //go to chat screen
      } else {
        //post notidy
        print("click notification open home screen");
        // showNotify.showNotifyPost(message.data);
        //go to home page
      }
    });

    //this event will work while open
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification.title == "chat") {
        showNotify.showNotifyMessage(message.notification);
      } else {
        //post notidy
        // print('notifications');
        showNotify.showNotifyPost(message.notification);
      }
    });

    //notification and go to app
    //check data from notification
    //and give go that screen ?
  }

  getDeviceToken() async {
    return await _fcm.getToken().then((token) {
      assert(token != null);
      saveTokenUser(token);
      print('my Device TOken : ' + token);
      return token;
    });
  }

  // Future<void> questSendNotify() async {
  //   Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  //   final pref = await _pref;
  // }

  Future<void> onSubscribe(String topic, String type) async {
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    final pref = await _pref;

    await _fcm.subscribeToTopic(topic).then((value) {
      //shared preference
      pref.remove(type);
      pref.setBool(type, true);
      print('subscribeToTopic :$topic success');
    });
  }

  Future<void> unSubscribe(String topic, String type) async {
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    final pref = await _pref;

    await _fcm.unsubscribeFromTopic(topic).then((value) {
//shared preference
      pref.remove(type);
      pref.setBool(type, false);
      print('unsubscribeFromTopic :$topic success');
    });
  }

  Future<void> saveTokenUser(String token) async {
    final _mRef = FirebaseFirestore.instance;
    final _mAuth = FirebaseAuth.instance;

    //shared preference
    Future<SharedPreferences> _pref = SharedPreferences.getInstance();
    final pref = await _pref;

    //get uid your current user
    _mAuth.authStateChanges().listen((user) async {
      // print(user.uid);
      if (user != null) {
        pref.setString("uid", user.uid);

        await _mRef
            .collection("user info")
            .doc(user.uid)
            .update({'deviceToken': '${token}'})
            .then((value) => print("save device token success"))
            .catchError((e) => print(e));
      }
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
        android: initializationSettingsAndroid, iOS: initializationSettingsIos);

    flutterNotify.initialize(
      initializationSettings,
      onSelectNotification: (payload) {
        // when user tap on notification.
        print("onSelectNotification called. data");
      },
    );
  }

  showNotifyMessage(RemoteNotification message) async {
    //create android ip channel description channel
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "notify_post",
      "post",
      "show notify to friends",
      category: "messaging",
      importance: Importance.high,
      priority: Priority.high,
      channelShowBadge: true,
    );

    //create ios setting notify
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    //create platform ios android noify
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    //show notify
    //id notify_post 1
    await flutterNotify.show(
        11, "" + message.title, message.body, platformChannelSpecifics,
        payload: 'FLUTTER_NOTIFICATION_CLICK');
  }

  showNotifyPost(RemoteNotification message) async {
    //create android ip channel description channel
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      "notify_post",
      "post",
      "show notify to friends",
      importance: Importance.high,
      priority: Priority.high,
    );

    //create ios setting notify
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    //create platform ios android noify
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    //show notify
    //id notify_post 1
    await flutterNotify.show(
        1, "" + message.title, message.body, platformChannelSpecifics,
        payload: 'FLUTTER_NOTIFICATION_CLICK');
  }
}
