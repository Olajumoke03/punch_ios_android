import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DisqusScreen extends StatefulWidget {
  String? slug,id;

  DisqusScreen({this.slug,this.id});
  @override
  _DisqusScreenState createState() => _DisqusScreenState();
}

class _DisqusScreenState extends State<DisqusScreen> {
  FontSizeController? _fontSizeController;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  bool isLoading=true;
  final _key = UniqueKey();
  String? url;



  @override
  void initState() {
    super.initState();
  _fontSizeController = Provider.of<FontSizeController>(context, listen: false);
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();


  }



  @override
  Widget build(BuildContext context) {
    url = "https://punchng.com/disqus-payload/?slug=" +
    widget.slug!+"&id="+widget.id! ;
    print(url);
    return  Scaffold(
        appBar:  AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Comments", textAlign: TextAlign.center,
              style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold)),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: Stack(
          children: [
            WebView (
              key: _key,
              initialUrl:url,
              javascriptMode: JavascriptMode.unrestricted ,
              onWebViewCreated: (
                  WebViewController webViewController) {
                _controller.complete ( webViewController );
              } ,

              navigationDelegate: (NavigationRequest request) {
//                         if (request.url.startsWith('https://www.youtube.com/')) {
//                           return NavigationDecision.prevent;
//                         }
                return NavigationDecision.navigate;
              } ,
              onPageStarted: (String url) {
                setState(() {
                  isLoading = true;
                });
              } ,
              onPageFinished: (String url) {
                setState(() {
                isLoading = false;
              });
                } ,
              gestureNavigationEnabled: false ,
              initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy
                  .always_allow ,

            ),
            isLoading ? Center( child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),)
                : Stack(),
          ],
        )
    );
  }
}



