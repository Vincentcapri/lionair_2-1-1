// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, use_build_context_synchronously, non_constant_identifier_names

import "dart:async";
import 'dart:convert';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:lionair_2/screens/laporan.dart';
import 'package:status_alert/status_alert.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'package:xml/xml.dart' as xml;

class InputLaporan extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;
  var data3;
  var data4;
  var vidx4;
  var bookin3;
  var bookout3;

  InputLaporan(
      {super.key,
      required this.userapi,
      required this.passapi,
      required this.data,
      required this.data1,
      required this.data2,
      required this.data3,
      required this.data4,
      required this.vidx4,
      required this.bookin3,
      required this.bookout3});

  @override
  State<InputLaporan> createState() => _InputLaporanState(userapi, passapi,
      data, data1, data2, data3, data4, vidx4, bookin3, bookout3);
}

class _InputLaporanState extends State<InputLaporan> {
  _InputLaporanState(
      this.userapi,
      this.passapi,
      this.data,
      this.data1,
      this.data2,
      this.data3,
      this.data4,
      this.vidx4,
      this.bookin3,
      this.bookout3);

  final _formKey = GlobalKey<FormState>();

  Xml2Json xml2json = Xml2Json();

  var loading = false;
  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];
  List result = [];
  var hasilJson;
  var vidx4;
  var bookin3;
  var bookout3;
  var userapi;
  var passapi;

  DateTime selectDate = DateTime.now();

  String location = 'Balaraja';
  String category = 'KEAMANAN/KETERTIBAN';
  final items = ['Balaraja', 'Makassar', 'Manado'];
  List<String> listCategory = [
    'KEAMANAN/KETERTIBAN',
    'KEBERSIHAN',
    'KERUSAKAN BARANG'
  ];

  final TextEditingController vidx = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController destination = TextEditingController();

  DropdownMenuItem<String> buildmenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );

  void _addReport(String vidx, String description) async {
    String namaasli = data[0]['namaasli'];
    vidx = vidx4;

    final String soapEnvelope = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<TenantReport_Entry xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
        '<Destination>$location</Destination>' +
        '<VIDX>$vidx</VIDX>' +
        '<CATEGORY>$category</CATEGORY>' +
        '<DESCRIPTION>$description</DESCRIPTION>' +
        '<USERINSERT>$namaasli</USERINSERT>' +
        '</TenantReport_Entry>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_TenantReport_Entry),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/TenantReport_Entry',
          'Access-Control-Allow-Credentials': 'true',
          'Content-type': 'text/xml; charset=utf-8'
        },
        body: soapEnvelope);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = xml.XmlDocument.parse(responseBody);
      final result = parsedResponse.findAllElements('_x002D_').single.text;
      debugPrint('Result: $result');
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Input Data4 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
  }

  void updateData4(String destination, String vidx) async {
    final temporaryList4_1 = [];
    vidx = vidx4;
    data4.clear();

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

      final list_result_all6 = document.findAllElements('_x002D_');

      for (final list_result in list_result_all6) {
        final idx = list_result.findElements('IDX').first.text;
        final vidx = list_result.findElements('VIDX').first.text;
        final date = list_result.findElements('DATE').first.text;
        final category = list_result.findElements('CATEGORY').first.text;
        final description = list_result.findElements('DESCRIPTION').first.text;
        final resolution = list_result.findElements('RESOLUTION').first.text;
        final userinsert = list_result.findElements('USERINSERT').first.text;
        final status = list_result.findElements('STATUS').first.text;
        temporaryList4_1.add({
          'idx': idx,
          'vidx': vidx,
          'date': date,
          'category': category,
          'description': description,
          'resolution': resolution,
          'userinsert': userinsert,
          'status': status
        });
        debugPrint("object 6");
        hasilJson = jsonEncode(temporaryList4_1);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 6");
      }

      Future.delayed(const Duration(seconds: 3), () {
        StatusAlert.show(context,
            duration: const Duration(seconds: 1),
            configuration:
                const IconConfiguration(icon: Icons.done, color: Colors.green),
            title: "Input Data Success",
            subtitle: "Please Refresh!!",
            backgroundColor: Colors.grey[300]);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Lihatlaporan(
              userapi: userapi,
              passapi: passapi,
              data: data,
              data1: data1,
              data2: data2,
              data3: data3,
              data4: data4,
              vidx4: vidx4,
              bookin3: bookin3,
              bookout3: bookout3),
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
        title: "Update4 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      data4 = temporaryList4_1;
      loading = true;
      // debugPrint('$dataBaru4');
    });
  }

  @override
  void initState() {
    super.initState();
    vidx.text = vidx4;
    destination.text = location;
  }

  @override
  void dispose() {
    vidx.dispose();
    description.dispose();
    destination.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Complaint",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).textScaleFactor * 33,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        const Text('Date'),
                        Text(
                          DateFormat('MMM dd, yyyy').format(selectDate),
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Mess Location",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              value: location,
                              iconSize: 23,
                              isExpanded: true,
                              items: items.map(buildmenuItem).toList(),
                              onChanged: (value) {
                                setState(() {
                                  location = value!;
                                });
                              }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      enabled: false,
                      controller: vidx,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Reservation ID",
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Category",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              value: category,
                              iconSize: 23,
                              isExpanded: true,
                              items: listCategory.map(buildmenuItem).toList(),
                              onChanged: (value) {
                                setState(() {
                                  category = value!;
                                });
                              }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: description,
                      maxLength: 85,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: loading
                          ? null
                          : () async {
                              if (location == 'Makassar' ||
                                  location == 'Manado') {
                                StatusAlert.show(
                                  context,
                                  duration: const Duration(seconds: 1),
                                  configuration: const IconConfiguration(
                                      icon: Icons.error, color: Colors.red),
                                  title: "Still On Progress",
                                  backgroundColor: Colors.grey[300],
                                );
                              } else {
                                setState(() {
                                  loading = true;
                                });
                                _addReport(vidx.text, description.text);
                                Future.delayed(const Duration(seconds: 1), () {
                                  updateData4(destination.text, vidx.text);
                                });
                              }
                            },
                      child: loading
                          ? const SizedBox(
                              height: 28,
                              width: 30,
                              child: CircularProgressIndicator())
                          : const Text("Submit"),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Lihatlaporan(
                userapi: userapi,
                passapi: passapi,
                data: data,
                data1: data1,
                data2: data2,
                data3: data3,
                data4: data4,
                vidx4: vidx4,
                bookin3: bookin3,
                bookout3: bookout3,
              ),
            ));
          },
          backgroundColor: Colors.red,
          elevation: 12,
          tooltip: "Back to Report",
          child: const Icon(
            Icons.cancel_outlined,
            size: 45,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
