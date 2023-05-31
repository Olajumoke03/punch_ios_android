

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punch_ios_android/category_list/bloc.dart';
import 'package:punch_ios_android/featured_news/featured_news_bloc.dart';
import 'package:punch_ios_android/home_news/home_bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/screens/home_page.dart';
import 'package:punch_ios_android/utility/ad_open_admanager.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState ();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  @override
  void initState() {
    super.initState();
    appOpenAdManager.loadAd();

    startTime();
  }
  startTime() async {
    var duration =  const Duration(seconds: 3);
    return  Timer(duration, nextPage);
  }


  nextPage() async {
    if(mounted){
      appOpenAdManager.showAdIfAvailable();

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
        child: SizedBox (
          width: 300.0,
          height: 100.0,
          child: Image.asset('assets/splash_logo.png'),
        ),
      ),
    );
  }
}
