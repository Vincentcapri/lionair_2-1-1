// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lionair_2/screens/rating.dart';
import 'package:status_alert/status_alert.dart';
import 'laporan.dart';
import '../constants.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'reservasi_mess.dart';
import 'package:clipboard/clipboard.dart';

class LihatDataEmployee extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;
  var data3;

  LihatDataEmployee(
      {super.key,
      required this.userapi,
      required this.passapi,
      required this.data,
      required this.data1,
      required this.data2,
      required this.data3});

  @override
  State<LihatDataEmployee> createState() =>
      _LihatDataEmployeeState(userapi, passapi, data, data1, data2, data3);
}

class _LihatDataEmployeeState extends State<LihatDataEmployee> {
  _LihatDataEmployeeState(this.userapi, this.passapi, this.data, this.data1,
      this.data2, this.data3);

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool loading1 = false;
  bool loading2 = false;
  bool _isConnected = true;

  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];
  List data7 = [];
  List dataBaru3 = [];
  var hasilJson;
  var vidxBaru;
  var bookinBaru;
  var bookoutBaru;
  var userapi;
  var passapi;

  TextEditingController destination = TextEditingController();
  TextEditingController idpegawai = TextEditingController();
  TextEditingController vidx = TextEditingController();

  void updateData3(String destination, String idpegawai) async {
    final temporaryList3_1 = [];
    String idpegawai = data[0]['idemployee'];
    data3.clear();

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<Checktime_GetHistoryStay xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
        '<Destination>BLJ</Destination>' +
        '<IDSTAFF>$idpegawai</IDSTAFF>' +
        '</Checktime_GetHistoryStay>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_Checktime_GetHistoryStay),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/Checktime_GetHistoryStay',
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'text/xml; charset=utf-8',
          // 'Accept': 'application/json',
        },
        body: objBody);

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);

      final listResultAll4 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll4) {
        final idx = list_result.findElements('IDX').first.text;
        final docstate = list_result.findElements('DOCSTATE').first.text;
        final idkamar = list_result.findElements('IDKAMAR').first.text;
        final areamess = list_result.findElements('AREAMESS').first.text;
        final blok = list_result.findElements('BLOK').first.text;
        final nokamar = list_result.findElements('NOKAMAR').first.text;
        final namabed = list_result.findElements('NAMABED').first.text;
        final bookin = list_result.findElements('BOOKIN').first.text;
        final bookout = list_result.findElements('BOOKOUT').first.text;
        if (docstate == "VOID") {
          temporaryList3_1.add({
            'idx': idx,
            'docstate': docstate,
            'idkamar': idkamar,
            'areamess': areamess,
            'blok': blok,
            'nokamar': nokamar,
            'namabed': namabed,
            'bookin': bookin,
            'bookout': bookout,
          });
        } else {
          final checkin = list_result.findElements('CHECKIN').first.text;
          final checkout = list_result.findElements('CHECKOUT').first.text;
          temporaryList3_1.add({
            'idx': idx,
            'docstate': docstate,
            'idkamar': idkamar,
            'areamess': areamess,
            'blok': blok,
            'nokamar': nokamar,
            'namabed': namabed,
            'bookin': bookin,
            'bookout': bookout,
            'checkin': checkin,
            'checkout': checkout
          });
        }
        debugPrint("object 3.1");
        hasilJson = jsonEncode(temporaryList3_1);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 3.1");
      }
      Future.delayed(const Duration(seconds: 3), () {
        Map<String, dynamic> map1 =
            Map.fromIterable(data3, key: (e) => e['idx']);
        Map<String, dynamic> map2 =
            Map.fromIterable(dataBaru3, key: (e) => e['idx']);

        map1.addAll(map2);

        List mergedList = map1.values.toList();

        // debugPrint('$mergedList');

        setState(() {
          data3 = mergedList;
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
        title: "Update3 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      dataBaru3 = temporaryList3_1;
      loading = true;
      // debugPrint('$dataBaru3');
    });
  }

  void getReport(String destination, String vidx, index) async {
    final temporaryList4 = [];
    vidx = data3[index]['idx'];
    String bookin = data3[index]['bookin'];
    String bookout = data3[index]['bookout'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<TenantReport_GetDataVIDX xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
        '<Destination>BLJ</Destination>' +
        '<VIDX>$vidx</VIDX>' +
        '</TenantReport_GetDataVIDX>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_TenantReport_GetDataVIDX),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/TenantReport_GetDataVIDX',
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'text/xml; charset=utf-8',
        },
        body: objBody);

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);

      // debugPrint("=================");
      // debugPrint(
      //     "document.toXmlString : ${document.toXmlString(pretty: true, indent: '\t')}");
      // debugPrint("=================");

      final listResultAll5 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll5) {
        final idx = list_result.findElements('IDX').first.text;
        final vidx = list_result.findElements('VIDX').first.text;
        final date = list_result.findElements('DATE').first.text;
        final category = list_result.findElements('CATEGORY').first.text;
        final description = list_result.findElements('DESCRIPTION').first.text;
        final resolution = list_result.findElements('RESOLUTION').first.text;
        final userinsert = list_result.findElements('USERINSERT').first.text;
        final status = list_result.findElements('STATUS').first.text;
        temporaryList4.add({
          'idx': idx,
          'vidx': vidx,
          'date': date,
          'category': category,
          'description': description,
          'resolution': resolution,
          'userinsert': userinsert,
          'status': status
        });
        debugPrint("object 4");
        hasilJson = jsonEncode(temporaryList4);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 4");
      }
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Lihatlaporan(
            userapi: userapi,
            passapi: passapi,
            data: data,
            data1: data1,
            data2: data2,
            data3: data3,
            data4: data4,
            vidx4: vidxBaru,
            bookin3: bookinBaru,
            bookout3: bookoutBaru,
          ),
        ));
        setState(() {
          loading1 = false;
        });
      });
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Get Data4 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      data4 = temporaryList4;
      vidxBaru = vidx;
      bookinBaru = bookin;
      bookoutBaru = bookout;
      loading1 = true;
    });
  }

  void getRating(String vidx, index) async {
    final temporaryList7 = [];
    vidx = data3[index]['idx'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<RATING_GetDataByVIDX xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
        '<Destination>BLJ</Destination>' +
        '<VIDX>$vidx</VIDX>' +
        '</RATING_GetDataByVIDX>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_RATING_GetDataByVIDX),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/RATING_GetDataByVIDX',
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'text/xml; charset=utf-8',
        },
        body: objBody);

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);

      // debugPrint("=================");
      // debugPrint(
      //     "document.toXmlString : ${document.toXmlString(pretty: true, indent: '\t')}");
      // debugPrint("=================");

      final listResultAll5 = document.findAllElements('_x002D_');

      for (final list_result in listResultAll5) {
        final idx = list_result.findElements('IDX').first.text;
        final name = list_result.findElements('NAME').first.text;
        final rating = list_result.findElements('RATING').first.text;
        temporaryList7.add({
          'idx': idx,
          'rating': rating,
          'name': name,
        });
        debugPrint("object 10");
        hasilJson = jsonEncode(temporaryList7);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 10");
      }
      Future.delayed(const Duration(seconds: 1), () {
        if (data7.isNotEmpty) {
          if (double.parse(data7[index]['rating']) == 0) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LihatRating(
                userapi: userapi,
                passapi: passapi,
                data: data,
                data1: data1,
                data2: data2,
                data3: data3,
                data7: data7,
              ),
            ));
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      icon: Icon(
                        Icons.error_outline,
                        color: Colors.amber,
                        size: MediaQuery.of(context).size.height * 0.1,
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Yes"),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LihatRating(
                                userapi: userapi,
                                passapi: passapi,
                                data: data,
                                data1: data1,
                                data2: data2,
                                data3: data3,
                                data7: data7,
                              ),
                            ));
                          },
                        ),
                        TextButton(
                          child: const Text("No"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text("You have rated us"),
                              Text("Want to update your Rating?"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LihatRating(
              userapi: userapi,
              passapi: passapi,
              data: data,
              data1: data1,
              data2: data2,
              data3: data3,
              data7: data7,
            ),
          ));
        }
        setState(() {
          loading2 = false;
        });
      });
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Get Data10 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading2 = false;
      });
    }
    setState(() {
      data7 = temporaryList7;
      loading2 = true;
    });
  }

  void logout() {
    setState(() {
      data.clear();
      data1.clear();
      data2.clear();
      data3.clear();
      data4.clear();
    });

    Navigator.pushReplacementNamed(context, 'login');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            data3.clear();
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Reservation History"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              updateData3(destination.text, idpegawai.text);
            },
            tooltip: "Refresh Data",
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
          : loading
              ? const Center(child: CircularProgressIndicator())
              : data3.isEmpty
                  ? Container(
                      alignment: Alignment.topCenter,
                      child: const Text("No Data"),
                    )
                  : ListView.builder(
                      key: _formKey,
                      itemCount: data3.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.all(8),
                          elevation: 8,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  color: Colors.black12,
                                  height: 45,
                                  child: Row(children: [
                                    GestureDetector(
                                      child: Row(
                                        children: [
                                          Text(
                                            "${data3[index]['idx']} ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .textScaleFactor *
                                                    18),
                                          ),
                                          const Icon(
                                            Icons.copy_rounded,
                                            color: Colors.black38,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        FlutterClipboard.copy(
                                            '${data3[index]['idx']}'); // copy teks ke clipboard
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Reservation ID copied!'),
                                          ),
                                        );
                                      },
                                    ),
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    Text(
                                      "${data3[index]['idkamar']}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                                ),
                                const Divider(
                                  thickness: 2,
                                ),
                                Row(
                                  children: [
                                    const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Text("Area"),
                                          ]),
                                          Row(children: [
                                            Text("Block"),
                                          ]),
                                          Row(children: [
                                            Text("Number"),
                                          ]),
                                          Row(
                                            children: [
                                              Text("Bed"),
                                            ],
                                          ),
                                        ]),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Text(
                                              " ${data3[index]['areamess']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: MediaQuery.of(context)
                                                        .textScaleFactor *
                                                    13,
                                              ),
                                            )
                                          ]),
                                          Row(children: [
                                            Text(
                                              " ${data3[index]['blok']}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .textScaleFactor *
                                                          13),
                                            ),
                                          ]),
                                          Row(children: [
                                            Text(
                                              " ${data3[index]['nokamar']}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .textScaleFactor *
                                                          13),
                                            )
                                          ]),
                                          Row(
                                            children: [
                                              Text(
                                                " ${data3[index]['namabed']}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: MediaQuery.of(
                                                                context)
                                                            .textScaleFactor *
                                                        13),
                                              ),
                                            ],
                                          )
                                        ]),
                                    const Spacer(
                                      flex: 1,
                                    ),
                                    data3[index]['docstate'] == "VOID"
                                        ? Padding(
                                            padding: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.015),
                                            child: Container(
                                              width: 80,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  border: Border.all(
                                                      color: Colors.red)),
                                              child: const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "VOID",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            // height: 48,
                                            // width: 95,
                                            padding: EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.035),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        IconButton(
                                                          iconSize: 50,
                                                          icon: loading2
                                                              ? const CircularProgressIndicator()
                                                              : const Icon(Icons
                                                                  .sentiment_neutral_outlined),
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              176, 176, 171),
                                                          onPressed: loading2
                                                              ? null
                                                              : () async {
                                                                  setState(() {
                                                                    loading2 =
                                                                        true;
                                                                  });
                                                                  getRating(
                                                                      vidx.text,
                                                                      index);
                                                                },
                                                        ),
                                                        const Text("Rate Us"),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 2,
                                ),
                                Row(
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Text("Book-In"),
                                        ]),
                                        Row(children: [
                                          Text("Book-Out"),
                                        ]),
                                        Row(children: [
                                          Text("Check-In"),
                                        ]),
                                        Row(
                                          children: [
                                            Text("Check-Out"),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Text(
                                            DateFormat(' : MMM dd, yyyy')
                                                .format(DateTime.parse(
                                                        data3[index]['bookin'])
                                                    .toLocal()),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                        Row(children: [
                                          Text(
                                            DateFormat(' : MMM dd, yyyy')
                                                .format(DateTime.parse(
                                                        data3[index]['bookout'])
                                                    .toLocal()),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ]),
                                        Row(children: [
                                          data3[index]['checkin'] == null
                                              ? const Text(
                                                  " : NULL",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : Text(
                                                  DateFormat(' : MMM dd, yyyy')
                                                      .format(DateTime.parse(
                                                              data3[index]
                                                                  ['checkin'])
                                                          .toLocal()),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                        ]),
                                        Row(
                                          children: [
                                            data3[index]['checkout'] == null
                                                ? const Text(
                                                    " : NULL",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text(
                                                    DateFormat(
                                                            ' : MMM dd, yyyy')
                                                        .format(DateTime.parse(
                                                                data3[index][
                                                                    'checkout'])
                                                            .toLocal()),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReservasiMess(
              userapi: userapi,
              passapi: passapi,
              data: data,
              data1: data1,
              data2: data2,
            ),
          ));
        },
        backgroundColor: Colors.red,
        elevation: 12,
        tooltip: "Add Reservation",
        child: const Icon(Icons.add),
      ),
    );
  }
}
