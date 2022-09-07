import 'package:shared_preferences/shared_preferences.dart';


class CacheRepository{
  SharedPreferences? prefs;
  void openCache() async {
     prefs =  await SharedPreferences.getInstance();
  }


}