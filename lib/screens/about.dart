// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class About extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;

  About({
    super.key,
    required this.userapi,
    required this.passapi,
    required this.data,
    required this.data1,
    required this.data2,
  });

  @override
  State<About> createState() =>
      _AboutState(userapi, passapi, data, data1, data2);
}

class _AboutState extends State<About> {
  _AboutState(this.userapi, this.passapi, this.data, this.data1, this.data2);

  bool loading = false;

  List data = [];
  List data1 = [];
  List data2 = [];
  var userapi;
  var passapi;
  var appsVersion;
  var appsBuild;

  Future<void> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String appVersion = packageInfo.version;
    final String appBuild = packageInfo.buildNumber;
    setState(() {
      appsVersion = appVersion;
      appsBuild = appBuild;
    });
  }

  Future<void> logout() async {
    setState(() {
      data.clear();
      data1.clear();
      data2.clear();
    });

    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Image.asset(
              'assets/images/appsicon.png',
              scale: 5,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Lion Reserve",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).textScaleFactor * 30,
                  letterSpacing: 10),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Version:",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor * 20),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "$appsVersion build $appsBuild",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor * 20),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "\u00A9 Copyright 2023",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).textScaleFactor * 15),
            ),
          ],
        ),
      ),
    );
  }
}
