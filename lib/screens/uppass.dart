// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lionair_2/screens/profile.dart';
import 'package:status_alert/status_alert.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'package:xml/xml.dart' as xml;

class UpdatePassword extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;
  var data3;

  UpdatePassword({
    super.key,
    required this.userapi,
    required this.passapi,
    required this.data,
    required this.data1,
    required this.data2,
    required this.data3,
  });

  @override
  State<UpdatePassword> createState() =>
      _UpdatePasswordState(userapi, passapi, data, data1, data2, data3);
}

class _UpdatePasswordState extends State<UpdatePassword> {
  _UpdatePasswordState(this.userapi, this.passapi, this.data, this.data1,
      this.data2, this.data3);

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _isConnected = true;

  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  var userapi;
  var passapi;

  TextEditingController newpass = TextEditingController();
  TextEditingController renewpass = TextEditingController();

  void updatePass(String newpass) async {
    String idstaff = data[0]['username'];
    String userinsert = data[0]['namaasli'];

    final String soapEnvelope = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<UserWeb_UpdatePass xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
        '<Destination>BLJ</Destination>' +
        '<IDStaff>$idstaff</IDStaff>' +
        '<NewPass>$newpass</NewPass>' +
        '<UserInsert>$userinsert</UserInsert>' +
        '</UserWeb_UpdatePass>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_UserWeb_UpdatePass),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/UserWeb_UpdatePass',
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'text/xml; charset=utf-8',
        },
        body: soapEnvelope);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = xml.XmlDocument.parse(responseBody);
      final result = parsedResponse.findAllElements('_x002D_').single.text;
      debugPrint('Result: $result');
      Future.delayed(const Duration(seconds: 1), () {
        StatusAlert.show(context,
            duration: const Duration(seconds: 1),
            configuration:
                const IconConfiguration(icon: Icons.done, color: Colors.green),
            title: "Update Data Success",
            backgroundColor: Colors.grey[300]);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UserProfile(
            userapi: userapi,
            passapi: passapi,
            data: data,
            data1: data1,
            data2: data2,
            data3: data3,
          ),
        ));
        setState(() {
          loading = false;
        });
      });
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Update Pass Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
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
    newpass.dispose();
    renewpass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => UserProfile(
                userapi: userapi,
                passapi: passapi,
                data: data,
                data1: data1,
                data2: data2,
                data3: data3,
              ),
            ));
          },
        ),
        title: const Text("Update Password"),
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
              itemCount: 1,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(15),
                  elevation: 8,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          // autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                autocorrect: false,
                                controller: newpass,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: '*****',
                                  labelText: 'New Password',
                                  icon: Icon(Icons.lock_outlined),
                                ),
                                //VALIDATOR Password
                                validator: (value) {
                                  return (value != null && value.length >= 3)
                                      ? null
                                      : 'Password must be greater than or equal to 3 characters';
                                },
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                autocorrect: false,
                                controller: renewpass,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: '*****',
                                  labelText: 'Re-type Password',
                                  icon: Icon(Icons.lock_reset),
                                ),
                                //VALIDATOR Password
                                validator: (value) {
                                  return (newpass.text == renewpass.text)
                                      ? null
                                      : "Password don't match, Please check again!!";
                                },
                              ),
                              const SizedBox(height: 30),
                              loading
                                  ? const SizedBox(
                                      height: 28,
                                      width: 30,
                                      child: CircularProgressIndicator())
                                  : MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      disabledColor: Colors.grey,
                                      color: Colors.red,
                                      onPressed: loading
                                          ? null
                                          : () async {
                                              setState(() {
                                                loading = true;
                                              });
                                              if (newpass.text !=
                                                  renewpass.text) {
                                                StatusAlert.show(
                                                  context,
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  configuration:
                                                      const IconConfiguration(
                                                          icon: Icons.error,
                                                          color: Colors.red),
                                                  title: "Password don't match",
                                                  subtitle:
                                                      "Please check again!!",
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                );
                                                setState(() {
                                                  loading = false;
                                                });
                                              } else if (newpass.text.isEmpty &&
                                                  renewpass.text.isEmpty) {
                                                StatusAlert.show(
                                                  context,
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  configuration:
                                                      const IconConfiguration(
                                                          icon: Icons.error,
                                                          color: Colors.red),
                                                  title:
                                                      "Password can't be empty",
                                                  subtitle:
                                                      "Please check again!!",
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                );
                                                setState(() {
                                                  loading = false;
                                                });
                                              } else {
                                                updatePass(newpass.text);
                                              }
                                            },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 80, vertical: 15),
                                        child: const Text('Update',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
