// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:status_alert/status_alert.dart';
import '../constants.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import 'lihat_reservasi.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class LihatRating extends StatefulWidget {
  var userapi;
  var passapi;
  var data;
  var data1;
  var data2;
  var data3;
  var data7;

  LihatRating({
    super.key,
    required this.userapi,
    required this.passapi,
    required this.data,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.data7,
  });

  @override
  State<LihatRating> createState() =>
      _LihatRatingState(userapi, passapi, data, data1, data2, data3, data7);
}

class _LihatRatingState extends State<LihatRating> {
  _LihatRatingState(this.userapi, this.passapi, this.data, this.data1,
      this.data2, this.data3, this.data7);

  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool loading1 = false;

  List data = [];
  List data1 = [];
  List data2 = [];
  List data3 = [];
  List data7 = [];
  var hasilJson;
  var userapi;
  var passapi;
  late double ratingBaru;

  TextEditingController destination = TextEditingController();
  TextEditingController idpegawai = TextEditingController();
  TextEditingController vidx = TextEditingController();
  final TextEditingController _rating = TextEditingController();

  void updateRating(String _rating, index) async {
    String idx = data7[index]['idx'];
    _rating = String.fromCharCode(ratingBaru.round() + 48);
    String objBody = '<?xml version="1.0" encoding="utf-8"?>' +
        '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">' +
        '<soap:Body>' +
        '<RATING_UpdateData xmlns="http://tempuri.org/">' +
        '<UsernameAPI>$userapi</UsernameAPI>' +
        '<PasswordAPI>$passapi</PasswordAPI>' +
        '<Destination>BLJ</Destination>' +
        '<IDX>$idx</IDX>' +
        '<Rating>$_rating</Rating>' +
        '</RATING_UpdateData>' +
        '</soap:Body>' +
        '</soap:Envelope>';

    final response = await http.post(Uri.parse(url_RATING_UpdateData),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*",
          'SOAPAction': 'http://tempuri.org/RATING_UpdateData',
          'Access-Control-Allow-Credentials': 'true',
          'Content-type': 'text/xml; charset=utf-8'
        },
        body: objBody);

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
        title: "Input Data7 Failed, ${response.statusCode}",
        backgroundColor: Colors.grey[300],
      );
    }
  }

  logout() {
    data.clear();
    data1.clear();
    data2.clear();
    data3.clear();
    data7.clear();
  }

  @override
  void dispose() {
    idpegawai.dispose();
    vidx.dispose();
    destination.dispose();
    _rating.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            data7.clear();
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Rating"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: data7.isEmpty
          ? Container(
              alignment: Alignment.topCenter,
              child: const Text("Still on Progress"),
            )
          : ListView.builder(
              shrinkWrap: true,
              key: _formKey,
              itemCount: data7.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8),
                  elevation: 8,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          '${data7[index]['name']}',
                        ),
                        RatingBar.builder(
                          initialRating: double.parse(data7[index]['rating']),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return const Icon(
                                  Icons.sentiment_very_dissatisfied,
                                  color: Colors.red,
                                );

                              case 1:
                                return const Icon(
                                  Icons.sentiment_dissatisfied,
                                  color: Colors.orange,
                                );
                              case 2:
                                return const Icon(
                                  Icons.sentiment_neutral,
                                  color: Colors.amber,
                                );
                              case 3:
                                return const Icon(
                                  Icons.sentiment_satisfied,
                                  color: Colors.lightGreen,
                                );
                              case 4:
                                return const Icon(
                                  Icons.sentiment_very_satisfied,
                                  color: Colors.green,
                                );
                              default:
                                return Container();
                            }
                          },
                          onRatingUpdate: (rating) {
                            setState(() {
                              ratingBaru = rating;
                              // print(rating);
                            });
                            updateRating(_rating.text, index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
