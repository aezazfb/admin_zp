import 'dart:convert';

import 'package:admin_zp/globalVars.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<void> backgroundMessageHandler(RemoteMessage theMsg) async {
  print('Title: ${theMsg.notification?.title}');
  print('Body: ${theMsg.notification?.body}');
  print('Payload: ${theMsg.data}');
}


class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  //Doing this for local notifications when app is on foreground/open
  final _androidChannel = const AndroidNotificationChannel('high_importance_channel', 'High_Importance_Notifications',
  description: 'This channel is used for importanat notifications',
  importance: Importance.defaultImportance
  );

  final _localAppOnNotifications = FlutterLocalNotificationsPlugin();


  void handleMessage(RemoteMessage? remoteMessage){
    if(remoteMessage == null) return;

    Get.toNamed(RoutesStr.LOGIN,
        arguments: remoteMessage);
  }


  //this is important for iOS
  Future initPushNotification() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
    );
    _firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    //for local notification on app foreground / on open app
    FirebaseMessaging.onMessage.listen((theMsg) {
      final theNotification = theMsg.notification;
      if(theNotification == null) return;

      _localAppOnNotifications.show(theNotification.hashCode,
          theNotification.title,
          theNotification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher'
            )
          ),
        payload: jsonEncode(theMsg.toMap()),
      );
    });
  }

  Future initLocalNotifications() async{
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(iOS: iOS, android: android);

    await _localAppOnNotifications.initialize(settings,
        onDidReceiveNotificationResponse: (result) {
          final theMsg = RemoteMessage.fromMap(jsonDecode(result.payload!));
          handleMessage(theMsg);
        }
    );

    final platform = _localAppOnNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(_androidChannel);
  }


  Future<void> initNotification() async{
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    theFCMToken.value = fCMToken!;
    print("This is fCMToken: $theFCMToken");

    // FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    //Calling PushNotification settings method
    initPushNotification();

    //Calling Notifications when APP is on
    initLocalNotifications();

  }

  //Sending msg //Access Token Required in Authorization Header
  Future createPushNotification(String title, String messageBody) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/zestypantry/messages:send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ya29.a0AfB_byDGcJXDYS06G2-cWfhfQ4gD05D1n5mkD7aBd_POQIVETSyTnWeuL5GkTM-NfN3wTWVF5C1VQP65BCzdLt78oR3qL9c3Fb4sIEdIUDMUWlEBiV0-g0Mdp8bHRPTZj9I3_sox6xv44t8BNxNUUpwejcFD0LMaCgYKAbwSARMSFQHsvYlsajat7egC1Nx7fKOzAyrXag0166',
      },
      body: jsonEncode(<String, dynamic>{
        "message":{
          "token":"emlV9IpnQNiMzrxOuwFClQ:APA91bHL8-tsmSaaRNoEWaNNsuwzHu9-PSDETUrloyrGiYxg3DFwMgcdTON5zTNNAEO8lavToOnYBbci-mfJA91a42UkmRiMR6qB1KXOqLxcROmVJp4r65LgxxqWGvNaJvdpYqQehBzd",
          "data":{},
          "notification":{
            "title":title,
            "body":messageBody,
          }
        }
      }),
    );

    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception(response.body);
    }
  }
}