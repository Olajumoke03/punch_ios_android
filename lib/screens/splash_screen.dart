// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:punch_ios_android/category_list/bloc.dart';
// import 'package:punch_ios_android/home_news/home_bloc.dart';
// import 'package:punch_ios_android/home_news/home_screen.dart';
// import 'package:punch_ios_android/repository/news_repository.dart';
// import 'package:punch_ios_android/utility/colors.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   late Repository repository;
//   @override
//   void initState() {
//     super.initState();
//     startTime();
//   }
//   startTime() async {
//     var duration =  const Duration(seconds: 3);
//     return Timer(duration, nextPage);
//   }
//
//   nextPage() async {
//
//     if(mounted){
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context)=>
//           MultiBlocProvider(
//             child: const HomeNewsScreen(),
//             providers: [
//               BlocProvider(create: (context) => HomeNewsBloc(repository: Repository()),),
//               BlocProvider(create: (context) => CategoryListBloc(repository: Repository()),   ),
//             ],
//           ),
//         // HomePage()
//       ));
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       backgroundColor:Theme.of(context).primaryColor ,
//       body: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children:  const [
//              Text("Punch News",
//               style: TextStyle(color:whiteColor, fontSize: 35, fontWeight: FontWeight.w700 ), // Punch in splash screen
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punch_ios_android/category_list/bloc.dart';
import 'package:punch_ios_android/featured_news/featured_news_bloc.dart';
import 'package:punch_ios_android/home_news/home_bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/screens/home_page.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState ();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    startTime();
  }
  startTime() async {
    var duration = new Duration(seconds: 3);
    return new Timer(duration, nextPage);
  }


  nextPage() async {
    if(mounted){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context)=>
          MultiBlocProvider(
            child:  HomePage(),
            providers: [
              BlocProvider(create: (context) => HomeNewsBloc(repository: Repository()),),
              BlocProvider(create: (context) => CategoryListBloc(repository: Repository()),),
              BlocProvider(create: (context) => FeaturedNewsBloc(repository: Repository()),),
            ],
          ),
        // HomePage()
      ));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300.0,
          height: 100.0,
          child: Image.asset('assets/splash_logo.png'),
        ),
      ),
    );
  }
}
