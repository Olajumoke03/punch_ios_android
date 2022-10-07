import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:punch_ios_android/utility/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() {
    checkTheme();
  }
  String isNotificationOn = "1";
  ThemeData theme = Constants.lightTheme;
  Key key = UniqueKey();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void setKey(value) {
    key = value;
    notifyListeners();
  }

  void setNavigatorKey(value) {
    navigatorKey = value;
    notifyListeners();
  }

  void setTheme(value, c) {
    theme = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("theme", c).then((val) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor:
          c == "dark" ? Constants.darkPrimary : Constants.lightPrimary,
          statusBarIconBrightness:
          c == "dark" ? Brightness.light : Brightness.dark,
        ));
      });
    });
    notifyListeners();
  }

  void setNotificationEnabled(isEnabled) {
    isNotificationOn = isEnabled;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("isNotificationOn", isEnabled).then((val) {
        // isEnabled=="1"? OneSignal.shared.setSubscription(true): OneSignal.shared.setSubscription(false);
        isEnabled=="1"? OneSignal.shared.consentGranted(true): OneSignal.shared.consentGranted(false);

        // print("notificaion on" + isEnabled );
      });
    });
    notifyListeners();
  }

  ThemeData getTheme(value) {
    return theme;

  }

  Future<ThemeData> checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ThemeData t;
    String? r = prefs.getString("theme") ?? "light";


    isNotificationOn = (prefs.getString("isNotificationOn") ?? "1");

    // isNotificationOn = (prefs.getString("isNotificationOn") ?? "1")!;


    if (r == "light") {
      t = Constants.lightTheme;
      setTheme(Constants.lightTheme, "light");
    } else {
      t = Constants.darkTheme;
      setTheme(Constants.darkTheme, "dark");
    }

    return t;
  }


}
