import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;
import 'connect_ips_model.dart';

class ConnectIpsApp extends StatefulWidget {
  final tokens;
  final orderId;

  ConnectIpsApp(this.tokens, this.orderId);

  @override
  _ConnectIpsAppState createState() => _ConnectIpsAppState();
}

class _ConnectIpsAppState extends State<ConnectIpsApp> {
  late webview_flutter.WebViewController controller;
  var encodeing = Encoding.getByName('utf-8');

  var tokens = "";

  var now = new DateTime.now();
  var formatter = DateFormat('dd-MM-yyyy');

  var rng = new Random();
  var orderId;
  late String formattedDate;
  var message = "";
  @override
  void initState() {
    orderId = widget.orderId;
    formattedDate = formatter.format(now);
    super.initState();
  }

  Future<String> getTokens(message, bool isValidate) async {
    //TXNAMT in paisa
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
        if (isValidate) {
          _validateTransaction(
              connectIpsRes.token.toString(), widget.orderId, 1000);
        } else {
          tokens = connectIpsRes.token.toString();
        }
        // });
      }
    } else {
      print(response.reasonPhrase);
    }
    return tokens;
    // print("Tokens : $tokens");
  }

  void loadLocalHtml(token) async {
    ////////// --------- connect ips html form ------------ //////////////
    var connect_ips =
        '''<form action="https://uat.connectips.com:7443/connectipswebgw/loginpage" method="post"> <br> 
    MERCHANT ID 
    <input style = "font-size:50px" type="text" name="MERCHANTID" id="MERCHANTID" value="569"/> 
    <br> 
     <br> 
    APP ID 
    <input style = "font-size:50px" type="text" name="APPID" id="APPID" value="MER-569-APP-1"/> 
    <br> 
     <br> 
    APP NAME 
    <input style = "font-size:50px" type="text" name="APPNAME" id="APPNAME" value="Job Pauchha"/> <br>  <br> 
    TXN ID 
    <input style = "font-size:50px" type="text" name="TXNID" id="TXNID" value="${orderId.toString()}"/>  <br> 
    <br> 
    TXN DATE 
    <input style = "font-size:50px" type="text" name="TXNDATE" id="TXNDATE" value="$formattedDate"/>  <br> 
    <br>
    TXN CRNCY 
    <input style = "font-size:50px" type="text" name="TXNCRNCY" id="TXNCRNCY" value="NPR"/>  <br> 
    <br> 
    TXN AMT 
    <input style = "font-size:50px" type="text" name="TXNAMT" id="TXNAMT" value="1000"/>  <br> 
    <br> 
    REFERENCE ID 
    <input style = "font-size:50px" type="text" name="REFERENCEID" id="REFERENCEID" value="REF-${orderId.toString()}"/> <br>  <br> 
    REMARKS 
    <input style = "font-size:50px" type="text" name="REMARKS" id="REMARKS" value="RMKS-${orderId.toString()}"/>  <br> 
    <br> 
    PARTICULARS 
    <input style = "font-size:50px" type="text" name="PARTICULARS" id="PARTICULARS" value="PART-${orderId.toString()}"/> <br>  <br> 
    TOKEN 
    <input style = "font-size:50px" type="text" name="TOKEN" id="TOKEN" value="${widget.tokens.toString()}"/> 
    <br>  <br> 
     <input type="submit" value="Submit" style = "font-size:50px; width: 300px; margin: 0 auto;" align="center"> 
    </form>''';
    print("Tokens1 : ${widget.tokens}");
    final url = Uri.dataFromString(connect_ips,
            mimeType: 'text/html', encoding: encodeing)
        .toString();
    controller.loadUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Connect Ips"),
        ),
        body: webview_flutter.WebView(
          javascriptMode: webview_flutter.JavascriptMode.unrestricted,
          onWebResourceError: (webviewerrr) {
            print("Handle your Error Page here $webviewerrr");
          },
          onWebViewCreated: (controller) {
            this.controller = controller;
            loadLocalHtml(widget.tokens);
          },
          gestureNavigationEnabled: true,
          onPageFinished: (_) {
            readResponse();
          },
        ));
  }

  ////////// -------- get transaction response here ----------- //////////////
  void readResponse() async {
    setState(() {
      controller
          .evaluateJavascript("document.documentElement.innerHTML")
          .then((value) async {
        if (value.contains(
            "Thank you for joining with us. Your payment has been successful.")) {
          print("yes");
          var string =
              "MERCHANTID=569,APPID=MER-569-APP-1,REFERENCEID=${orderId.toString()},TXNAMT=${1000}";
          await getTokens(string, true);
          // Navigator.pop(context);
        } else if (value.contains("Sorry! Transaction failed...")) {
          print("yes");
          // _showMyDialog("Already Joined");
          Navigator.pop(context);
        } else {
          print("No");
        }
        print("ValueContains : $value");
      });
    });
  }

////////// -------- validate transaction ----------- ////////////////
  _validateTransaction(token, txid, amt) async {
    var headers = {
      'Authorization': 'Basic TUVSLTU2OS1BUFAtMTpBYmNkQDEyMw==',
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://uat.connectips.com:7443/connectipswebws/api/creditor/validatetxn'));
    request.body = json.encode({
      "merchantId": 569,
      "appId": "MER-569-APP-1",
      "referenceId": txid.toString(),
      "txnAmt": amt,
      "token": token.toString()
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
