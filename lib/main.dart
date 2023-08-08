import 'dart:io';

import 'package:admin_zp/app/data/functionalities/firebaseMessaging.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Platform.isAndroid?
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(apiKey: 'AIzaSyBjBuVCnRnvC4GjaBY6fCu162E6bJk9YYw',
  //       appId: '1:574551489741:android:6abca60fd2786b9408bd84',
  //       messagingSenderId: '574551489741', projectId: 'zestypantry')
  // ) :
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInAnonymously();

  // var credential = Credentials.applicationDefault();
  // credential ??= await Credentials.login();
  // var app = FirebaseAdmin.instance.initializeApp(AppOptions(
  //     credential: credential,
  //     projectId: 'zestypantry'));
  // try {
  //   // get a user by email
  //   var v = await app.auth().getUserByEmail('jane@doe.com');
  //   print(v.toJson());
  // } on Exception catch (e) {
  //   print(e.toString());
  // }

  await FirebaseApi().initNotification();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
