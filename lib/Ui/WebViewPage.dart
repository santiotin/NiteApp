import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:niteapp/Utils/AppLocalizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({Key key, this.url}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();

}
class _WebViewPageState extends State<WebViewPage> {

  Completer<WebViewController> _controller = Completer<WebViewController>();

  bool loadingUrl = true;

  @override
  Widget build(BuildContext context) {
    print(loadingUrl.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('buy')),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      body:
        WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.url,
          onWebViewCreated: (WebViewController webViewController) {
            setState(() {
              _controller.complete(webViewController);
              loadingUrl = false;
            });
          },
          onPageFinished: (value) {
            setState(() {
              loadingUrl = false;
            });
          },
        ),
    );
  }
}