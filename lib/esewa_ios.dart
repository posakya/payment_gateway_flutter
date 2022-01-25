import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;

class EsewaPayIos extends StatefulWidget {
  const EsewaPayIos({Key? key}) : super(key: key);

  @override
  _EsewaPayIosState createState() => _EsewaPayIosState();
}

class _EsewaPayIosState extends State<EsewaPayIos> {
  late webview_flutter.WebViewController controller;
  var encodeing = Encoding.getByName('utf-8');

  void loadLocalHtml() async {
    ////////// --------- esewa html form ------------ //////////////
    var esewa = ''' <form
                      action="https://uat.esewa.com.np/epay/main"
                      method="post"
                    >
                       <input value="100" name="tAmt" type="hidden">
                       <input value="90" name="amt" type="hidden">
                       <input value="5" name="txAmt" type="hidden">
                       <input value="2" name="psc" type="hidden">
                       <input value="3" name="pdc" type="hidden">
                       <input value="EPAYTEST" name="scd" type="hidden">
                       <input value="ee2c3ca1-696b-4cc5-a6be-2c40d929d453" name="pid" type="hidden">
                      <input
                        value="http://localhost/payment_gateway/esewa_success_mbl.php"
                        type="hidden"
                        name="su"
                      />
                      <input
                        value="http://localhost/payment_gateway/esewa_failed_mbl.php"
                        type="hidden"
                        name="fu"
                      />
                      <input
                        value="Join Now"
                        type="submit"
                         style = "font-size:50px; width: 300px; margin: 0 auto;"
                      />
                    </form> ''';
    final url =
        Uri.dataFromString(esewa, mimeType: 'text/html', encoding: encodeing)
            .toString();
    controller.loadUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("eSewa iOS"),
        ),
        body: webview_flutter.WebView(
          javascriptMode: webview_flutter.JavascriptMode.unrestricted,
          onWebResourceError: (webviewerrr) {
            print("Handle your Error Page here $webviewerrr");
          },
          onWebViewCreated: (controller) {
            this.controller = controller;
            loadLocalHtml();
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

          Navigator.pop(context);
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
}
