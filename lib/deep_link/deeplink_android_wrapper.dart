import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:punch_ios_android/deep_link/bloc.dart';
import 'package:punch_ios_android/deep_link/deeplink_details_bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/screens/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'deeplink_news_details_with_bloc.dart';

class DeepLinkAndroidWrapper extends StatefulWidget {
  const DeepLinkAndroidWrapper({Key? key}) : super(key: key);

  @override
  _DeepLinkAndroidWrapperState createState() => _DeepLinkAndroidWrapperState();
}

class _DeepLinkAndroidWrapperState extends State<DeepLinkAndroidWrapper> {
  launchAdvertise(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context, listen: false);

    return StreamBuilder<String>(
        stream: _bloc.state,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            print ("url link is null: " + snapshot.data.toString());
            return SplashScreen();
          }
          else if(snapshot.data!.contains('https://punchng.com/advertise-with-us')){
            launchAdvertise() async {
              const url = 'https://punchng.com/advertise-with-us';
              if (await canLaunch(url)) {
                await launch(url, forceWebView: true, forceSafariVC: true, );
              } else {
                throw 'Could not launch $url';
              }
            }
            launchAdvertise();
            print('the url link' + snapshot.data!);
          }

          print("this is the news url " + snapshot.data!.replaceAll("https://punchng.com/", "")
              .replaceAll("/", "").replaceAll("?utm_source=OneSignal&utm_medium=web-push","")
              .replaceAll("?amp", " "));

          return BlocProvider<DeepLinkDetailsBloc>(
            create: (context) => DeepLinkDetailsBloc(repository: Repository()),
            child: DeepLinkNewsDetailsBloc(slug: snapshot.data!.replaceAll("https://punchng.com/", "")
                .replaceAll("/", "").replaceAll("?utm_source=OneSignal&utm_medium=web-push"," ")
                .replaceAll("?amp", " ").replaceAll("?", "  ")
            ),
          );
        });
  }
}