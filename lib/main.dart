import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_funding_choices/flutter_funding_choices.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:punch_ios_android/utility/ad_open_admanager.dart';
import 'package:punch_ios_android/utility/app_open_notifier.dart';
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
import 'package:hive/hive.dart';
import 'package:flutter_funding_choices/flutter_funding_choices.dart' as funding;



void main() async {
  Hive.initFlutter();

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  // To test ads on emulator
  // List<String> testDeviceIds = ['0A4B0C1D7F49C398BB22D65451DF4F4D'];
  List<String> testDeviceIds = ['D78FD65D77C59942A261E6E1C9B4FE45'];
  RequestConfiguration configuration = RequestConfiguration(testDeviceIds: testDeviceIds);
  // ConsentDebugSettings.Builder().addTestDeviceHashedId("D78FD65D77C59942A261E6E1C9B4FE45")
  MobileAds.instance.updateRequestConfiguration(configuration);



  // Admob.initialize();
  // await Admob.requestTrackingAuthorization();

  // App Tracking Transparency
  final status = await AppTrackingTransparency.requestTrackingAuthorization();
  final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();

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

        // Provider(create: (context) => FavoriteListModel()),
        // ChangeNotifierProxyProvider<FavoriteListModel, FavoritePageModel>(
        //     create: (context) => FavoritePageModel(),
        //     update: (context, favoriteList, favoritepage){
        //       if (favoritepage = null)
        //     }
        // )

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
  late AppLifecycleReactor _appLifecycleReactor;
  String _authStatus = 'Unknown';

  //IN-APP UPDATE
  AppUpdateInfo? _updateInfo;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }



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

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt.
// We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      // print("Accepted permission: $accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    // OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
    //   this.setState(() {
    //     _debugLabelString =
    //     "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    //   });
    // });

    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
      // Will be called whenever a notification is opened/button pressed.

      // print ("clicked notification " + result.notification.jsonRepresentation());

      var data = result.notification.additionalData;

      // print("this is the data response for notification = " + data!["custom"].toString());

      Navigator.push(_appProvider!.navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) =>
              DeepLinkNewsDetails(slug: data!['custom'].toString().replaceAll('https://punchng.com/', '')))
      );

      // print("i reached here too = " + data!['custom'].toString());
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

    //App Open Ad
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor = AppLifecycleReactor(
    appOpenAdManager: appOpenAdManager);

    // ConsentDebugSettings debugSettings = ConsentDebugSettings.Builder(this)
    //     .setDebugGeography(ConsentDebugSettings
    //     .DebugGeography
    //     .DEBUG_GEOGRAPHY_EEA)
    //     .addTestDeviceHashedId("E044C97978FC060327A4C4F01EE86A88")
    //     .build();
    //
    // // Google CMP implementation:
    // ConsentRequestParameters params = new ConsentRequestParameters
    //     .Builder()
    //     .setTagForUnderAgeOfConsent(false)
    //     .setConsentDebugSettings(debugSettings)
    //     .build();


    // App Tracking Transparency
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) => initPlugin());


    //Flutter Funding Choices
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
            tagForChildDirectedTreatment:
            TagForChildDirectedTreatment.unspecified,
            testDeviceIds: <String>["D78FD65D77C59942A261E6E1C9B4FE45,0A4B0C1D7F49C398BB22D65451DF4F4D"]),
      );
      // ConsentDebugSettings().addTestDeviceHashedId("D78FD65D77C59942A261E6E1C9B4FE45");
      funding.ConsentInformation consentInfo = await FlutterFundingChoices.requestConsentInformation();
      if (consentInfo.isConsentFormAvailable && consentInfo.consentStatus == funding.ConsentStatus.REQUIRED_ANDROID) {
        await FlutterFundingChoices.showConsentForm();
        // You can check the result by calling `FlutterFundingChoices.requestConsentInformation()` again !
      }
      if (consentInfo.isConsentFormAvailable && consentInfo.consentStatus == funding.ConsentStatus.REQUIRED_IOS) {
        await FlutterFundingChoices.showConsentForm();
        // You can check the result by calling `FlutterFundingChoices.requestConsentInformation()` again !
      }

      // print("flutter funding choice something");
      FlutterFundingChoices.requestConsentInformation();
      print("flutter funding choice something");

    });


  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
      await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    // print("UUID: $uuid");
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
                'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
                'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

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
            home: Scaffold(
                body:Provider<DeepLinkBloc>(
                    create: (context) => _bloc,
                    child:DeepLinkWrapper())
            )
          // home: MyHomePage(),
          // routes: {
          //   "DetailedNewsPage": (context) => NewsDetailPage(),
          // },
        );
      },
    );
  }
}




