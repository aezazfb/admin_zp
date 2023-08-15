import 'dart:convert';

import 'package:admin_zp/globalVars.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

Future<void> backgroundMessageHandler(RemoteMessage theMsg) async {
  // print('Title: ${theMsg.notification?.title}');
  // print('Body: ${theMsg.notification?.body}');
  // print('Payload: ${theMsg.data}');
}


class FirebaseApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  //Doing this for local notifications when app is on foreground/open
  final _androidChannel = const AndroidNotificationChannel('high_importance_channel', 'High_Importance_Notifications',
  description: 'This channel is used for importanat notifications',
  importance: Importance.defaultImportance
  );

  final _localAppOnNotifications = FlutterLocalNotificationsPlugin();


  //This function is performed when notification is opened!
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

    thisDeviceFCMToken.value = fCMToken!;
    print("This is device fCMToken: $thisDeviceFCMToken");

    // FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    //Calling PushNotification settings method
    initPushNotification();

    //Calling Notifications when APP is on
    initLocalNotifications();

  }

  //Sending msg //Access Token Required in Authorization Header
  Future createPushNotification(String title, String messageBody, String accessToken, String deviceFcm) async {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/zestypantry/messages:send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, dynamic>{
        "message":{
          "token":deviceFcm,
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


  Future<String> generateAccessToken() async {
    // Load the service account JSON key from file
    final String serviceAccountJson = await rootBundle.loadString('lib/assets/service-account.json'); // Update path

    // Parse the JSON
    final Map<String, dynamic> credentialsJson = json.decode(serviceAccountJson);

    // Create a ServiceAccountCredentials instance
    final ServiceAccountCredentials credentials =
    ServiceAccountCredentials.fromJson(credentialsJson);

    // Create a client
    final client = await clientViaServiceAccount(credentials, ['https://www.googleapis.com/auth/firebase.messaging']);

    // Generate an access token
    final AccessCredentials accessCredentials = client.credentials;
    final String accessToken = accessCredentials.accessToken.data;

    //print('Access Token: $accessToken');

    return accessToken;
  }
}