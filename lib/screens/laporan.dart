// ignore_for_file: library_prefixes, depend_on_referenced_packages, must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lionair_2/screens/images.dart';
import 'package:status_alert/status_alert.dart';
import '../constants.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'input_laporan.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class Lihatlaporan extends StatefulWidget {
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

  Lihatlaporan(
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
  State<Lihatlaporan> createState() => _Lihatlaporanstate(userapi, passapi,
      data, data1, data2, data3, data4, vidx4, bookin3, bookout3);
}

class _Lihatlaporanstate extends State<Lihatlaporan> {
  _Lihatlaporanstate(
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

  int _currentIndex = 2;

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
  List data5 = [];
  List data6 = [];
  var hasilJson;
  var vidx4;
  var bookin3;
  var bookout3;
  var userapi;
  var passapi;
  var idreffbaru;

  TextEditingController destination = TextEditingController();
  TextEditingController vidx = TextEditingController();
  TextEditingController idreff = TextEditingController();
  TextEditingController idfile = TextEditingController();

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

  void getIDFile(String idreff, index) async {
    final temporaryList6 = [];
    idreff = data4[index]['idx'];

    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<File_GetDataFromIDReff xmlns="http://tempuri.org/">' +
        '<UsernameApi>$userapi</UsernameApi>' +
        '<PasswordApi>$passapi</PasswordApi>' +
        '<DESTINATION>BLJ</DESTINATION>' +
        '<IDRESERVATION>$idreff</IDRESERVATION>' +
        '</File_GetDataFromIDReff>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_File_GetDataFromIDReff),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/File_GetDataFromIDReff',
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
        final idfile = list_result.findElements('IDFILE').first.text;
        final filename = list_result.findElements('FILENAME').first.text;
        temporaryList6.add({
          'idfile': idfile,
          'filename': filename,
        });
        debugPrint("object 7");
        hasilJson = jsonEncode(temporaryList6);

        debugPrint(hasilJson);
        debugPrint("object_hasilJson 7");
      }

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Lihatgambar(
            userapi: userapi,
            passapi: passapi,
            data: data,
            data1: data1,
            data2: data2,
            data3: data3,
            data4: data4,
            data5: data5,
            idreff5: idreffbaru,
            vidx4: vidx4,
            bookin3: bookin3,
            bookout3: bookout3,
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
        title: "Get Data5 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading1 = false;
      });
    }
    setState(() {
      data5 = temporaryList6;
      idreffbaru = idreff;
      loading1 = true;
      // debugPrint('$dataBaru4');
    });
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
            data4.clear();
            vidx4 = '';
            bookin3 = '';
            bookout3 = '';
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Complaint"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              updateData4(destination.text, vidx.text);
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
              : data4.isEmpty
                  ? Container(
                      alignment: Alignment.topCenter,
                      child: const Text("No Data"),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      key: _formKey,
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 10),
                                Text(
                                  "${data4[index]['vidx']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          20),
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Total Rows: ${data4.length}",
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                            15),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.72,
                                  child: DataTable2(
                                    columnSpacing: 1,
                                    horizontalMargin: 10,
                                    minWidth: 1303,
                                    columns: const [
                                      DataColumn(label: Text("IDX")),
                                      DataColumn(label: Text("Category")),
                                      DataColumn(label: Text("Date")),
                                      DataColumn2(
                                          label: Text("Description"),
                                          size: ColumnSize.L),
                                      DataColumn2(
                                          label: Text("Resolution"),
                                          size: ColumnSize.L),
                                      DataColumn2(
                                          label: Text("Status"),
                                          size: ColumnSize.S),
                                      DataColumn2(
                                          label: Text("Attachment"),
                                          size: ColumnSize.L),
                                    ],
                                    rows: List<DataRow>.generate(
                                      data4.length,
                                      (index) => DataRow(
                                        color: MaterialStateProperty
                                            .resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                          // Even rows will have a grey color.
                                          if (index.isOdd) {
                                            return Colors.grey.withOpacity(0.3);
                                          }
                                          return null; // Use default value for other states and odd rows.
                                        }),
                                        cells: <DataCell>[
                                          DataCell(
                                              Text("${data4[index]['idx']}")),
                                          DataCell(Text(
                                              "${data4[index]['category']}")),
                                          DataCell(Text(
                                              DateFormat('MMM d, yyyy').format(
                                                  DateTime.parse(
                                                          data4[index]['date'])
                                                      .toLocal()))),
                                          DataCell(Text(
                                              "${data4[index]['description']}")),
                                          DataCell(Text(
                                              "${data4[index]['resolution']}")),
                                          DataCell(Text(
                                            "${data4[index]['status']}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          )),
                                          DataCell(
                                            data4[index]['status'] == "CLOSE"
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.48,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent,
                                                          ),
                                                          onPressed: loading1
                                                              ? null
                                                              : () async {
                                                                  setState(() {
                                                                    loading1 =
                                                                        true;
                                                                  });
                                                                  getIDFile(
                                                                      idreff
                                                                          .text,
                                                                      index);
                                                                },
                                                          child: loading1
                                                              ? const SizedBox(
                                                                  height: 20,
                                                                  width: 22,
                                                                  child:
                                                                      CircularProgressIndicator())
                                                              : const Text(
                                                                  "View"),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MyAlertDialog(
                                                                userapi:
                                                                    userapi,
                                                                passapi:
                                                                    passapi,
                                                                data: data,
                                                                data1: data1,
                                                                data2: data2,
                                                                data3: data3,
                                                                data4: data4,
                                                                vidx4: vidx4,
                                                                bookin3:
                                                                    bookin3,
                                                                bookout3:
                                                                    bookout3,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: const Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .photo_library,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                "Choose Image",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                            ]),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                        ),
                                                        onPressed: loading1
                                                            ? null
                                                            : () async {
                                                                setState(() {
                                                                  loading1 =
                                                                      true;
                                                                });
                                                                getIDFile(
                                                                    idreff.text,
                                                                    index);
                                                              },
                                                        child: loading1
                                                            ? const SizedBox(
                                                                height: 20,
                                                                width: 22,
                                                                child:
                                                                    CircularProgressIndicator())
                                                            : const Text(
                                                                "View"),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
            builder: (context) => InputLaporan(
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
        tooltip: "Add Report",
        child: const Icon(Icons.add),
      ),
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
}

class MyAlertDialog extends StatefulWidget {
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

  MyAlertDialog(
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
  State<MyAlertDialog> createState() => _MyAlertDialogState(userapi, passapi,
      data, data1, data2, data3, data4, vidx4, bookin3, bookout3);
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  _MyAlertDialogState(
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

  bool loading = false;

  File? _image;
  String titleImage = "Choose Image";
  String titleCam = "Take Picture";

  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data4 = [];
  List data5 = [];
  List data6 = [];
  var hasilJson;
  var vidx4;
  var bookin3;
  var bookout3;
  var userapi;
  var passapi;
  var idreffbaru;

  void _getCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedImage != null && titleCam == "Take Picture") {
        titleCam = pickedImage.path;
        _image = File(pickedImage.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  void _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null && titleImage == "Choose Image") {
        titleImage = pickedImage.path;
        _image = File(pickedImage.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  void addImage(index) async {
    String namaasli = data[0]['namaasli'];
    String idreff = data4[index]['idx'];
    String kategori = data4[index]['category'];
    String base64Image = base64Encode(_image!.readAsBytesSync());
    String filename = Path.basename(_image!.path);

    final String soapEnvelope = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<File_Entry xmlns="http://tempuri.org/">' +
        '<UsernameApi>$userapi</UsernameApi>' +
        '<PasswordApi>$passapi</PasswordApi>' +
        '<DESTINATION>BLJ</DESTINATION>' +
        '<IDREFF>$idreff</IDREFF>' +
        '<FILENAME>$filename</FILENAME>' +
        '<FILEBYTE>$base64Image</FILEBYTE>' +
        '<FILECAT>$kategori</FILECAT>' +
        '<USERINSERT>$namaasli</USERINSERT>' +
        '</File_Entry>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_File_Entry),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/File_Entry',
          'Access-Control-Allow-Credentials': 'true',
          'Content-type': 'text/xml; charset=utf-8'
        },
        body: soapEnvelope);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = xml.XmlDocument.parse(responseBody);
      final result = parsedResponse.findAllElements('_x002D_').single.text;
      debugPrint('Result: $result');
      StatusAlert.show(context,
          duration: const Duration(seconds: 1),
          configuration:
              const IconConfiguration(icon: Icons.done, color: Colors.green),
          title: "Success",
          backgroundColor: Colors.grey[300]);
      setState(() {
        loading = false;
      });
    } else {
      debugPrint('Error: ${response.statusCode}');
      StatusAlert.show(
        context,
        duration: const Duration(seconds: 1),
        configuration:
            const IconConfiguration(icon: Icons.error, color: Colors.red),
        title: "Input Data5 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 1,
            child: AlertDialog(
              content: Stack(
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: Text(titleCam),
                        onTap: () async {
                          _getCamera();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: Text(titleImage),
                        onTap: () async {
                          _getImage();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text("Submit"),
                  onPressed: () {
                    addImage(index);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    titleImage = "Choose Image";
                    titleCam = "Take Picture";
                    Navigator.of(context).pop();
                  },
                ),
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
            ),
          );
        });
  }
}
