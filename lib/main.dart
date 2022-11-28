import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:punch_ios_android/utility/details_provider.dart';
import 'package:punch_ios_android/utility/favorites_provider.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:provider/provider.dart';
import 'package:punch_ios_android/utility/app_provider.dart';
import 'package:punch_ios_android/utility/constants.dart';
import 'package:punch_ios_android/utility/deeplink_news_details_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:punch_ios_android/utility/subcribe_to_newsletter_provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'deep_link/bloc.dart';
import 'deep_link/deeplink_news_details.dart';
import 'deep_link/deeplink_wrapper.dart';
import 'home_news/home_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  // Admob.initialize();

  // Initialize Firebase.
  await Firebase.initializeApp();
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => DeepLinkNewsDetailsProvider()),
        ChangeNotifierProvider(create: (_) => DetailsProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => SubscribeToNewsLetterProvider()),
        ChangeNotifierProvider(create: (_) => FontSizeController()),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
   final Uri? uri;
   const MyApp({Key? key, this.uri}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  HomeNewsModel? homeNewsModel;
  AppProvider? _appProvider;

  // Future<String?> initialLink() async {
  //   try {
  //     final initialLink = await getInitialLink();
  //     return initialLink;
  //   } on PlatformException catch (exception){
  //     print( exception.message);
  //   }
  // }
  // String deepLinkURL = " ";



  @override
  void initState() {
    super.initState();

    _appProvider = Provider.of<AppProvider>(context, listen: false);

    //for OneSignal
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId("ebcb0294-a654-4cb7-ac97-bad77f8bb444", );

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
      // Will be called whenever a notification is opened/button pressed.

      print ("clicked notification " + result.notification.jsonRepresentation());
      // var data = result.notification.payload.additionalData;

      var data = result.notification.additionalData;

      print("this is the data response for notification = " + data!["custom"].toString());

      Navigator.push(_appProvider!.navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) =>
              DeepLinkNewsDetails(slug: data['custom'].toString().replaceAll('https://punchng.com/', '')))
      );

      print("i reached here too = " + data['custom'].toString());
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver((OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }

  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = DeepLinkBloc();
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    return  Consumer<AppProvider>(
      builder: ( context,  appProvider,  child) {
        return MaterialApp(
            key: appProvider.key,
            debugShowCheckedModeBanner: false,
            navigatorKey: appProvider.navigatorKey,
            title: Constants.appName,
            theme: appProvider.theme,
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
            home:
            Scaffold(
                body:Provider<DeepLinkBloc>(
                    create: (context) => _bloc,
                    child:DeepLinkWrapper())
            )
            // Scaffold(
            //     body:Provider<DeepLinkBloc>(
            //         create: (context) => _bloc,
            //         child:DeepLinkWrapper())
            // )


        );
      },
    );
  }
}
