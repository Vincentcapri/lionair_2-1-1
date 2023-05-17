// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, non_constant_identifier_names, use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lionair_2/screens/about.dart';
import 'package:lionair_2/screens/profile.dart';
import 'reservasi_mess.dart';

class HomeScreen extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;

  HomeScreen(
      {super.key,
      required this.userapi,
      required this.passapi,
      required this.data,
      required this.data1,
      required this.data2});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState(userapi, passapi, data, data1, data2);
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeScreenState(
      this.userapi, this.passapi, this.data, this.data1, this.data2);

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool loading1 = false;
  bool _isConnected = true;

  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  var userapi;
  var passapi;

  Future<void> logout() async {
    setState(() {
      data.clear();
      data1.clear();
      data2.clear();
      data3.clear();
    });

    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = (result != ConnectivityResult.none);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'menu_1') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserProfile(
                    userapi: userapi,
                    passapi: passapi,
                    data: data,
                    data1: data1,
                    data2: data2,
                    data3: data3,
                  ),
                ));
              } else if (value == 'menu_2') {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const About(),
                ));
              } else if (value == 'menu_3') {
                logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'menu_1',
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Profile'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'menu_2',
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('App Info'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'menu_3',
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Log Out'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: !_isConnected
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No Internet Connection,'),
                  Text('Please Check Your Connection!!'),
                ],
              ),
            )
          : ListView.builder(
              key: _formKey,
              itemCount: 1,
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'),
                            ),
                          ),
                          width: double.infinity,
                          height: size.height * 0.1,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: size.width * 0.9,
                          height: size.height * 0.35,
                          child: Card(
                            color: Colors.white,
                            elevation: 8.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 15),
                                Text(
                                  "WELCOME",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          20),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                    "Name : ${data[index]['namaasli']}".trim()),
                                const SizedBox(height: 5),
                                Text("Username : ${data[index]['username']}"
                                    .trim()),
                                const SizedBox(height: 5),
                                Text(
                                    "ID Employee : ${data[index]['idemployee']}"
                                        .trim()),
                                const SizedBox(height: 10),
                                Container(
                                  margin: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 65,
                                        width: size.width * 0.8,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            elevation: 10.0,
                                            side: const BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                          onPressed: loading1
                                              ? null
                                              : () async {
                                                  setState(() {
                                                    loading1 = true;
                                                  });
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 1), () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          ReservasiMess(
                                                        userapi: userapi,
                                                        passapi: passapi,
                                                        data: data,
                                                        data1: data1,
                                                        data2: data2,
                                                      ),
                                                    ));
                                                    setState(() {
                                                      loading1 = false;
                                                    });
                                                  });
                                                },
                                          child: loading1
                                              ? const CircularProgressIndicator()
                                              : const Text(
                                                  "Mess Reservation",
                                                  style: TextStyle(
                                                      color: Colors.black54),
                                                  textAlign: TextAlign.center,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

List<Widget> indicators(dataLength, currentIndex) {
  return List<Widget>.generate(dataLength, (index) {
    return Container(
      margin: const EdgeInsets.all(3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black : Colors.black26,
          shape: BoxShape.circle),
    );
  });
}
