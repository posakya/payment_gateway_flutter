import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;

class NicApp extends StatefulWidget {
  @override
  _NicAppState createState() => _NicAppState();
}

class _NicAppState extends State<NicApp> {
  late webview_flutter.WebViewController controller;
  var encodeing = Encoding.getByName('utf-8');
  var isLoading = true;
  final _key = UniqueKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("NIC Asia"),
        ),
        body: Stack(
          children: [
            webview_flutter.WebView(
              key: _key,
              initialUrl:
                  "https://jobpauchha.com/payment/payment_confirmation.php?amount=20",
              javascriptMode: webview_flutter.JavascriptMode.unrestricted,
              onWebResourceError: (err) {
                print("Handle your Error Page here $err");
              },
              onWebViewCreated: (controller) {
                this.controller = controller;
              },
              gestureNavigationEnabled: true,
              onPageFinished: (_) {
                setState(() {
                  Future.delayed(Duration(seconds: 3), () {
                    setState(() {
                      isLoading = false;
                    });
                  });
                });
                readResponse();
              },
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              Stack(),
          ],
        ));
  }

  ////////// -------- get transaction response here ----------- //////////////
  void readResponse() async {
    setState(() {
      controller
          .evaluateJavascript("document.documentElement.innerHTML")
          .then((value) async {
        if (value.contains("Payment Acceptance - Receipt")) {
          print("yes");
          // Navigator.pop(context);
        } else if (value.contains("Sorry! Transaction failed...")) {
          print("!yes");
        } else {
          print("No");
        }
      });
    });
  }
}
