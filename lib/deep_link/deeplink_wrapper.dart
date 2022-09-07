// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:punch_ios_android/repository/news_repository.dart';
// // import 'package:punch_ios_android/screens/splash_screen.dart';
// // import 'package:provider/provider.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'bloc.dart';
// // import 'deeplink_details_bloc.dart';
// // import 'deeplink_news_details_with_bloc.dart';
// //
// // class DeepLinkWrapper extends StatefulWidget {
// //   @override
// //   _DeepLinkWrapperState createState() => _DeepLinkWrapperState();
// // }
// //
// // class _DeepLinkWrapperState extends State<DeepLinkWrapper> {
// //   launchAdvertise(String url) async {
// //     if (await canLaunch(url)) {
// //       await launch(url, forceWebView: true);
// //     } else {
// //       throw 'Could not launch $url';
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context, listen: false);
// //
// //     return StreamBuilder<String>(
// //         stream: _bloc.state,
// //         builder: (context, snapshot) {
// //           if (snapshot.data == null) {
// //             print ("snapshot.data (deeplink url) = "+ snapshot.data.toString());
// //             return SplashScreen();
// //           }
// //           else    if(snapshot.data!.contains('https://punchng.com/advertise-with-us')){
// //             launchAdvertise() async {
// //               const url = 'https://punchng.com/advertise-with-us';
// //               if (await canLaunch(url)) {
// //                 await launch(url, forceWebView: true, forceSafariVC: true, );
// //               } else {
// //                 throw 'Could not launch $url';
// //               }
// //             }
// //             launchAdvertise();
// //             print('the url link' + snapshot.data!);
// //
// //           }
// //
// //           print("this is the news url " + snapshot.data!.replaceAll("https://punchng.com/", "")
// //               .replaceAll("/", "").replaceAll("?utm_source=OneSignal&utm_medium=web-push","")
// //               .replaceAll("?amp", " "));
// //
// //           return BlocProvider<DeepLinkDetailsBloc>(
// //               create: (context) => DeepLinkDetailsBloc(repository: Repository()),
// //               child: DeepLinkNewsDetailsBloc(slug: snapshot.data!.replaceAll("https://punchng.com/", "")
// //                   .replaceAll("/", "").replaceAll("?utm_source=OneSignal&utm_medium=web-push","")
// //                   .replaceAll("?amp", " ")
// //                   .replaceAll("?", "  "))
// //           );
// //         });
// //   }
// //
// // }
// //
// //
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:punch_ios_android/deep_link/deeplink_details_bloc.dart';
// // // import 'package:punch_ios_android/repository/news_repository.dart';
// // // import 'package:punch_ios_android/screens/splash_screen.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:url_launcher/url_launcher.dart';
// // // import 'bloc.dart';
// // // import 'deeplink_news_details_with_bloc.dart';
// // //
// // // class DeepLinkAndroidWrapper extends StatefulWidget {
// // //   const DeepLinkAndroidWrapper({Key? key}) : super(key: key);
// // //
// // //   @override
// // //   _DeepLinkAndroidWrapperState createState() => _DeepLinkAndroidWrapperState();
// // // }
// // //
// // // class _DeepLinkAndroidWrapperState extends State<DeepLinkAndroidWrapper> {
// // //   launchAdvertise(String url) async {
// // //     if (await canLaunch(url)) {
// // //       await launch(url, forceWebView: true);
// // //     } else {
// // //       throw 'Could not launch $url';
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context, listen: false);
// // //
// // //     return StreamBuilder<String>(
// // //         stream: _bloc.state,
// // //         builder: (context, snapshot) {
// // //           if (snapshot.data == null) {
// // //             print ("deeplink url is null " + snapshot.data.toString());
// // //             return const SplashScreen();
// // //           }
// // //           else if(snapshot.data!.contains('https://punchng.com/advertise-with-us')){
// // //             launchAdvertise() async {
// // //               const url = 'https://punchng.com/advertise-with-us';
// // //               if (await canLaunch(url)) {
// // //                 await launch(url, forceWebView: true, forceSafariVC: true, );
// // //               } else {
// // //                 throw 'Could not launch $url';
// // //               }
// // //             }
// // //             launchAdvertise();
// // //             print('the url link' + snapshot.data!);
// // //           }
// // //
// // //
// // //           print("this is news url original " + snapshot.data!);
// // //           print("this is the news url formatted " + snapshot.data!.replaceAll("https://punchng.com/", "")
// // //               .replaceAll("/", "").
// // //           replaceAll("?utm_source=OneSignal&utm_medium=web-push","")
// // //               .replaceAll("?amp", " "));
// // //
// // //           return BlocProvider<DeepLinkDetailsBloc>(
// // //             create: (context) => DeepLinkDetailsBloc(repository: Repository()),
// // //             child: DeepLinkNewsDetailsBloc(slug: snapshot.data!.replaceAll("https://punchng.com/", "")
// // //                 .replaceAll("/", "").replaceAll("?utm_source=OneSignal&utm_medium=web-push"," ")
// // //                 .replaceAll("?amp", " ").replaceAll("?", "  ")
// // //             ),
// // //           );
// // //         });
// // //   }
// // //
// // // }
//
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:punch_ios_android/screens/splash_screen.dart';
// import 'package:punch_ios_android/utility/app_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:uni_links/uni_links.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'deeplink_news_details.dart';
// import 'package:flutter/services.dart' show PlatformException;
//
// class DeepLinkWrapper extends StatefulWidget {
//   DeepLinkWrapper({ this.uri});
//   final Uri? uri;
//   @override
//   State<DeepLinkWrapper> createState() => _DeepLinkWrapperState();
// }
//
// class _DeepLinkWrapperState extends State<DeepLinkWrapper> {
//   StreamSubscription? _sub;
//   AppProvider? _appProvider;
//
//   launchAdvertise(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url, forceWebView: true);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _appProvider = Provider.of<AppProvider>(context, listen: false);
//     checkDeepLink();
//   }
//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }
//   Future checkDeepLink() async {
//     try {
//       _sub = getLinksStream().listen((String? link) {
//         if (!mounted) return;
//         print('initPlatformStateForStringUniLinks         $link');
//       }, onError: (err) {
//         if (!mounted) return;
//         print('errr $err');
//       });
//
//       // Attach a second listener to the stream Note: The jump here should be when the APP is opened and cut to the background process.
//       getLinksStream().listen((String? link) {
//         print('initState  index   got link: $link');
//         SchedulerBinding.instance!.addPostFrameCallback((_) {
//           if(link.toString().contains('https://punchng.com/advertise-with-us')){
//             launchAdvertise() async {
//               const url = 'https://punchng.com/advertise-with-us';
//               if (await canLaunch(url)) {
//                 await launch(url, forceWebView: true, forceSafariVC: true, );
//               } else {
//                 throw 'Could not launch $url';
//               }
//             }
//             launchAdvertise();
//             print('the url link' + widget.uri.toString());
//
//           } else {
//             _appProvider!.navigatorKey.currentState!.push(
//                 MaterialPageRoute ( builder: (context) =>
//                     DeepLinkNewsDetails ( slug: link!
//                         .replaceAll ("https://punchng.com/", "" )
//                     // .replaceAll ("/", "" )
//                     // .replaceAll("?amp", "")
//                     // .replaceAll("?amp=1", "")
//                         .replaceAll("?", " ")
//                     ))
//             );
//           }
//           print("this is news  link " + link!
//           // .replaceAll ("/", "" )
//           // .replaceAll("?amp", "")
//           // .replaceAll("?amp=1", "")
//               .replaceAll("?", " "));
//
//         });
//
//       }, onError: (err) {
//         print('got err: $err');
//       });
//       // Get the latest link
//       String initialLink;
//       Uri initialUri;
//       // Platform messages may fail, so we use a try/catch PlatformException.
//       try {
//         // Remarks: This is the first time the APP has been opened and the received link will jump, which is why I haven’t summarized this article in a long time.
//         initialLink = (await getInitialLink())!;
//         print('initial link: $initialLink');
//         if(initialLink!=null){
//           if(initialLink.toString().contains('https://punchng.com/advertise-with-us')){
//             launchAdvertise() async {
//               const url = 'https://punchng.com/advertise-with-us';
//               if (await canLaunch(url)) {
//                 await launch(url, forceWebView: true, forceSafariVC: true, );
//               } else {
//                 throw 'Could not launch $url';
//               }
//             }
//             launchAdvertise();
//             print('the url link' + widget.uri.toString());
//
//           } else {
//             SchedulerBinding.instance!.addPostFrameCallback((_) {
//               _appProvider!.navigatorKey.currentState!.push(
//                   MaterialPageRoute ( builder: (context) =>
//                       DeepLinkNewsDetails ( slug: initialLink.replaceAll (
//                           "https://punchng.com/", "" ).replaceAll ("/", "" ) ) )
//               );
//             });
//           }
//         }
//
// //      if (initialLink != null) initialUri = Uri.parse(initialLink);
//       }catch(e){
//         print('error $e');
//       }
//     } on PlatformException {
//       print("PlatformException");
//     } on Exception {
//       print('Exception thrown');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     SchedulerBinding.instance!.addPostFrameCallback((_){
//       // take action according to data uri
//       print("the uri : " + widget.uri.toString());
//       if (widget.uri != null) {
//         print("the uri is not null : " + widget.uri.toString());
//
//         if(widget.uri.toString().contains('https://punchng.com/advertise-with-us')){
//           launchAdvertise() async {
//             const url = 'https://punchng.com/advertise-with-us';
//             if (await canLaunch(url)) {
//               await launch(url, forceWebView: true, forceSafariVC: true, );
//             } else {
//               throw 'Could not launch $url';
//             }
//           }
//           launchAdvertise();
//           print('the url link' + widget.uri.toString());
//
//         } else {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) =>
//                   DeepLinkNewsDetails(slug: widget.uri.toString().replaceAll("https://punchng.com/", "")
//                       .replaceAll("/", ""))));
//         }
//       }
//     });
//     return SplashScreen();
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punch_ios_android/deep_link/bloc.dart';
import 'package:punch_ios_android/deep_link/deeplink_details_bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'deeplink_news_details_with_bloc.dart';

class DeepLinkWrapper extends StatefulWidget {
  @override
  _DeepLinkWrapperState createState() => _DeepLinkWrapperState();
}

class _DeepLinkWrapperState extends State<DeepLinkWrapper> {
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
            // print ("problem , trying to build the first screen underneath" + snapshot.data.toString());
            return SplashScreen();
          }
          else    if(snapshot.data!.contains('https://punchng.com/advertise-with-us')){
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
                  .replaceAll("/", "").replaceAll("?utm_source=OneSignal&utm_medium=web-push","")
                  .replaceAll("?amp", " ")
                  .replaceAll("?", "  "))
          );
        });
  }

}