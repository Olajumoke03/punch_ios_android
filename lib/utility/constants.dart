import 'package:flutter/material.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:timeago/timeago.dart' as timeago;


const String baseUrl="https://punchng.com/wp-json/wp/v2/";
const String singleNews =baseUrl+"posts?slug=";

const String latestNews =baseUrl+"posts?per_page=20&page=1";
const String moreLatestNews =baseUrl+"posts?per_page=20&page=";

const String newsByCategory =baseUrl+"posts?per_page=20&page=1&categories=";
const String moreNewsByCategory =baseUrl+"posts?per_page=20&categories=";

const String newsTag =baseUrl+"posts?per_page=5&tags=";

const String searchResult =baseUrl+"search?per_page=20&search=";
const String moreSearchResult ="search?per_page=20&search=&page=";

const String privacyPolicy =baseUrl+"pages/778714";
const String aboutUs =baseUrl+"pages/164902";

// const String CATEGORY_LIST =BASE_URL+"categories?per_page=100";
const String categoryList ="https://punchng.com/category-payload/?v2";

const String featuredNews =baseUrl+"posts?categories=";

const String liveVideo ="https://punchng.com/mobile-app-streaming/";

// const String aboutUs ="pages/164902";


// newly added
const String netCoreUrl ="https://api.netcoresmartech.com/apiv2?type=contact&activity=add&apikey=28b46bfdfd06f61d3a5b1d266e0b30d8";


 String readNewTimestamp(String timestamp) {
final DateTime date = DateTime.parse(timestamp);

var time = timeago.format(date);
return time;

// final loadedTime =  DateTime.now();
//
//   final now = DateTime.now();
//   var difference = now.difference(loadedTime);
//   // mainContainer?.text = timeago.format(now.subtract(difference), locale: locale);
// return difference;
}

class Constants {

  static String readTimestamp(String timestamp) {
    final DateTime date = DateTime.parse(timestamp);

    var time = timeago.format(date);
    return time;

    // final loadedTime =  DateTime.now();
    //
    //   final now = DateTime.now();
    //   var difference = now.difference(loadedTime);
    //   // mainContainer?.text = timeago.format(now.subtract(difference), locale: locale);
    // return difference;
  }

  // Jiffy(DateTime.now()).fromNow; // a few seconds ago


  // static String readTimeStamp (String timestamp){
    // var orgTime = Jiffy().jm; //Tuesday, March 2, 2021 3:20 PM
    // final DateTime date = DateTime.parse(timestamp);

    // var time = Jiffy(DateTime.now(date)).fromNow; //Tuesday, March 2, 2021 3:20 PM
    // return time;
    //
    // var dateTime = Jiffy().add(hours: 3, months: 2);
    //
    // dateTime.fromNow(timestamp);
    // return dateTime;

    // final Jiffy date = DateTime.parse(timestamp) as Jiffy;
    // var dateTime = Jiffy(DateTime.now()).fromNow(date);
    // return dateTime;

  // }

  // static String timeformat(String timee){
  //   // final fifteenAgo = DateTime.now().subtract(timee);
  //   return fifteenAgo;
  //
  // }

  static String latestNewsCacheKey ="latest";
  static String featuredNewsCacheKey ="featured";

  static String appName = "Punch News";
  static String appPackage = "com.punch_news";

  static String appAbout =
  // "<h3>You can reach out to us .</h3>"
      "<h1>Reach out to us:</h1>"
      "<p>Phone: 08033298984</p>"
      "<p>Email: jnwokeoma@punchng.com</p>"
      "<p>Address: Punch Place,kilometer 14, Lagos-Ibadan express way </p>";


  //THEME
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = Colors.black;
  static Color lightAccent = mainColor;
  static Color darkAccent = mainColor;
  static Color lightBG = const Color(0xFFFAFAFA);
  static Color darkBG = Colors.grey.shade900;

  static ThemeData lightTheme = ThemeData(
    fontFamily: "Poppins",
    backgroundColor: lightBG,
    primaryColor: mainColor,
    primaryColorLight: greenColor,
    // colorScheme: lightTheme.colorScheme.copyWith(secondary: lightAccent),
    // cursorColor: lightAccent,
    cardColor: Colors.grey[50],
    scaffoldBackgroundColor: lightBG,
    primaryColorDark: whiteColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: whiteColor,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontFamily: "Poppins",
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    textTheme: TextTheme(
      headline1:  const TextStyle(color: mainColor, fontSize: 35, fontWeight: FontWeight.w400 ), // Punch News in splash screen
      headline2:  const TextStyle(color: mainColor, fontSize: 35, fontWeight: FontWeight.w700 ), // Punch News   in splash screen
      bodyText1: const TextStyle(color: blackColor, fontSize: 17, ),
      bodyText2: const TextStyle(color: blackColor, fontSize: 15),
      button: TextStyle(color: Colors.grey[200])
    ),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: "Poppins",
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: whiteColor,
    // colorScheme: darkTheme.colorScheme.copyWith(secondary: whiteColor),
    // cursorColor: lightAccent,
    scaffoldBackgroundColor: darkBG,
    // cursorColor: darkAccent,
    cardColor: Colors.black12,
    primaryColorDark: blackColor,

    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor:blackColor,
      textTheme: TextTheme(
        headline6: TextStyle(
          fontFamily: "Poppins",
          color: lightBG,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    textTheme: TextTheme(
      headline1: const TextStyle(color: whiteColor, fontSize: 15, fontWeight: FontWeight.w400), // news title
      bodyText1: const TextStyle(color: whiteColor, fontSize: 17),
      bodyText2: const TextStyle(color: Colors.black87,),
      button: TextStyle(color: Colors.grey[800])

    ),

  );

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

}
