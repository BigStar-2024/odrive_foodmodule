import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:odrive/backend/api_calls.dart';
import 'package:odrive/pages/recompense/recompense.dart';

import '../main.dart';

//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
final PointsUpdateNotifier pointsUpdateNotifier = PointsUpdateNotifier();
Stream<String>? _tokenStream;
// Initialize the [FlutterLocalNotificationsPlugin] package.
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Create a [AndroidNotificationChannel] for heads up notifications
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
  await Firebase.initializeApp();
}

void setToken(String? token) {
  if (token == null) return;
  print("Firebase messaging: token=$token");
  //account.setFcbToken(token);
  addNotificationToken(token);
}

firebaseInitApp(BuildContext context) async {
  print("firebaseInitApp");
  print("firebaseInitApp");
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null && message.notification != null) {
      print("FCB message _notifyCallback=;_notifyCallback ${message.from}");
      //account.addNotify();
      // if (message.data['chat'] != null){
      //   if (message.data['chat'] == "true") {
      //     if (_chatCallback != null)
      //       _chatCallback!();
      //     return;
      //   }
      // }
      // if (_notifyCallback != null)
      //   _notifyCallback!(message);
    }
  });

  firebaseGetToken(context);
  // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
  //   if (message != null && message.notification != null) {
  //     print("FCB message _notifyCallback=;_notifyCallback ${message.from}");
  //     if (message.data['chat'] != null){
  //       if (message.data['chat'] == "true") {
  //         if (_chatCallback != null)
  //           _chatCallback!();
  //         return;
  //       }
  //     }
  //     if (_notifyCallback != null)
  //       _notifyCallback!(message);
  //   }
  // }
  // );
}

firebaseGetToken(BuildContext context) async {
  print("Firebase messaging: _getToken");

  // iOS
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: true,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Create an Android Notification Channel.
  //
  // We use this channel in the `AndroidManifest.xml` file to override the
  // default FCM channel to enable heads up notifications.
  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //     AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // Update the iOS foreground notification presentation options to allow
  // heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  setToken(await FirebaseMessaging.instance.getToken());
  _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
  if (_tokenStream != null) _tokenStream!.listen(setToken);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification == null) return;
    if (_lastMessageId != null) if (_lastMessageId == message.messageId) return;
    _lastMessageId = message.messageId;
    print("FirebaseMessaging.onMessageOpenedApp $message ${message.from}");
    //account.addNotify();
    //account.chatRefresh();
    //account.notifyRefresh();
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("FirebaseMessaging.onMessage ${message.messageId}");
    print("Firebase messaging:onMessage: $message");
    print("Firebase message: ${message.data}");
    if (_lastMessageId != null) if (_lastMessageId == message.messageId) return;
    _lastMessageId = message.messageId;
    var tranfert = message.data["title"];
    if (tranfert != null && tranfert == 'Transfert de point') {
      pointsUpdateNotifier.notifyUpdate();
    }

    /* var _message = message.data["chat"];
    if (_message == 'true') {
      account.addChat();
      return;
    } */
    //account.addNotify();

    // print("${message.data['chat']}" );

    // if (message.data['chat'] != null){
    //   if (message.data['chat'] == "true") {
    //     if (_chatCallback != null)
    //       _chatCallback();
    //     return;
    //   }
    // }
    // if (_notifyCallback != null)
    //   _notifyCallback(message);
  });
}

String? _lastMessageId;

// Function(RemoteMessage message) _notifyCallback;
//
// setNotifyCallback(Function(RemoteMessage message) notifyCallback){
//   _notifyCallback = notifyCallback;
// }
//
// Function() _chatCallback;
//
// setChatCallback(Function() chatCallback){
//   _chatCallback = chatCallback;
// }


//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:fooddelivery/main.dart';
// import 'package:fooddelivery/model/dprint.dart';
//
// final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
//
// firebaseGetToken() async {
//   dprint ("Firebase messaging: _getToken");
//
//   firebaseMessaging.configure(
//     onMessage: (Map<String, dynamic> message) async {
//       dprint("Firebase messaging:onMessage: $message");
//       var _message = message["data"]["chat"];
//       if (_message == 'true'){
//         account.addChat();
//         return;
//       }
//       account.addNotify();
//     },
//     onLaunch: (Map<String, dynamic> message) async {
//       dprint("Firebase messaging:onLaunch: $message");
//     },
//     onResume: (Map<String, dynamic> message) async {
//       dprint("Firebase messaging:onResume: $message");
//       account.chatRefresh();
//       account.notifyRefresh();
//     },
//     //onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
//   );
//   firebaseMessaging.requestNotificationPermissions(
//       const IosNotificationSettings(
//           sound: true, badge: true, alert: true, provisional: false));
//
//   firebaseMessaging.onIosSettingsRegistered
//       .listen((IosNotificationSettings settings) {
//     dprint("Firebase messaging: Settings registered: $settings");
//
//   });
//
//   firebaseMessaging.getToken().then((String token) {
//     assert(token != null);
//     dprint ("Firebase messaging: token=$token");
//     account.setFcbToken(token);
//   });
// }