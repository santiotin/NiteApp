import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TicketWebView extends StatefulWidget {

  const TicketWebView({Key key}) : super(key: key);

  @override
  _TicketWebViewState createState() => _TicketWebViewState();

}
class _TicketWebViewState extends State<TicketWebView> {

  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('tickets')),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      body: WebView(
        initialUrl: 'https://www.google.com',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}