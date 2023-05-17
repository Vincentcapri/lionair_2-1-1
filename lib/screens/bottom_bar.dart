// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, non_constant_identifier_names, use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lionair_2/screens/home_screen.dart';
import 'package:lionair_2/screens/lihat_reservasi.dart';

import 'current.dart';
import 'pending.dart';

class BottomBar extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;
  var data3;

  BottomBar({
    super.key,
    required this.userapi,
    required this.passapi,
    required this.data,
    required this.data1,
    required this.data2,
    required this.data3,
  });

  @override
  State<BottomBar> createState() =>
      _BottomBarState(userapi, passapi, data, data1, data2, data3);
}

class _BottomBarState extends State<BottomBar> {
  _BottomBarState(this.userapi, this.passapi, this.data, this.data1, this.data2,
      this.data3);

  bool loading = false;
  bool loading1 = false;
  bool loading2 = false;
  bool loading3 = false;
  bool loading4 = false;
  bool _isConnected = true;

  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  var userapi;
  var passapi;

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

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          : _buildPageContent(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        selectedFontSize: 20,
        selectedItemColor: Colors.red,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Current',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return HomeScreen(
            userapi: userapi,
            passapi: passapi,
            data: data,
            data1: data1,
            data2: data2);
      case 1:
        return PendingScreen(
            userapi: userapi, passapi: passapi, data: data, data1: data1);
      case 2:
        return CurrentScreen(
            userapi: userapi,
            passapi: passapi,
            data: data,
            data1: data1,
            data2: data2);
      case 3:
        return LihatDataEmployee(
            userapi: userapi,
            passapi: passapi,
            data: data,
            data1: data1,
            data2: data2,
            data3: data3);
      default:
        return Container();
    }
  }
}
