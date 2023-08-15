import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/googleapis_auth.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _generateAccessToken();
  }

  void _generateAccessToken() async {
    // required dependencies:
    // http: ^package_version
    // googleapis_auth: ^package_version
    // googleapis: ^package_version


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
    final AccessCredentials accessCredentials = await client.credentials;
    final String accessToken = accessCredentials.accessToken.data;

    print('Access Token: $accessToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Token Generator'),
      ),
      body: const Center(
        child: Text('Generating access token...'),
      ),
    );
  }
}