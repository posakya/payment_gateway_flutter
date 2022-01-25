import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'connect_ips_app.dart';
import 'connect_ips_model.dart';
import 'esewa_ios.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  static const platform =
      const MethodChannel("com.app.codekarkhana/androidEsewa");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment Gateways Integration"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  getTokens(context);
                },
                icon: const Icon(Icons.arrow_right),
                label: const Text("Go To Connect Ips Payment")),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EsewaPayIos()));
                },
                icon: Icon(Icons.arrow_right),
                label: Text(" Go To eSewa Payment iOS ")),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
                onPressed: () {
                  eSewaPayAndroid();
                },
                icon: Icon(Icons.arrow_right),
                label: Text("Go To eSewa Payment Android")),
          ],
        ),
      ),
    );
  }

  void eSewaPayAndroid() async {
    String value = "";

    var rng = new Random();
    var orderId = rng.nextInt(900000) + 100000;

    var dataToPass = <String, dynamic>{
      'amount': '1',
      'productId': orderId.toString(),
      'productName': 'code karkhana product'
    };

    try {
      value = await platform.invokeMethod("androidesewa", dataToPass);
      print("Result $value");
    } catch (e) {
      print("Errorss : $e");
    }
  }

  //// get tokens for connect ips /////
  getTokens(context) async {
    //TXNAMT in paisa
    var now = new DateTime.now();
    var formatter = DateFormat('dd-MM-yyyy');
    var rng = new Random();
    var orderId = rng.nextInt(900000) + 100000;
    var formattedDate = formatter.format(now);
    var message =
        "MERCHANTID=569,APPID=MER-569-APP-1,APPNAME=Job Pauchha,TXNID=${orderId.toString()},TXNDATE=$formattedDate,TXNCRNCY=NPR,TXNAMT=${1000},REFERENCEID=REF-${orderId.toString()},REMARKS=RMKS-${orderId.toString()},PARTICULARS=PART-${orderId.toString()},TOKEN=TOKEN";

    var request = http.Request(
        'GET',
        Uri.parse(
            'https://jobpauchha.com/connectips/generate_tokens.php?name=' +
                message));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var jsonString = await http.Response.fromStream(response);
      final connectIpsRes = connectIpsResFromJson(jsonString.body);
      if (connectIpsRes.status == true) {
        // setState(() {
        print("Tokens : ${connectIpsRes.token.toString()}");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ConnectIpsApp(
                connectIpsRes.token.toString(), orderId.toString())));
        // tokens = connectIpsRes.token.toString();

        // });
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
