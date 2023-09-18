import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:punch_ios_android/category_list/bloc.dart';
import 'package:punch_ios_android/category_list/screen.dart';
import 'package:punch_ios_android/featured_news/featured_news_bloc.dart';
import 'package:punch_ios_android/home_news/home_bloc.dart';
import 'package:punch_ios_android/home_news/home_screen.dart';
import 'package:punch_ios_android/live_video/live_video_bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/screens/more_screen.dart';
import 'package:punch_ios_android/screens/saved_news_screen.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/utility/constants.dart';
import 'package:punch_ios_android/utility/favorites_provider.dart';
import 'package:punch_ios_android/widgets/custom_alert_dialog.dart';

class HomePage extends StatefulWidget{
  final Repository repository = Repository();

   HomePage({Key? key}) : super(key: key);


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  int _page = 0;

  final List<Widget> _children = [

    MultiBlocProvider(
      child: const HomeNewsScreen(),
      providers: [
        BlocProvider(create: (context) => HomeNewsBloc(repository: Repository()),),
        BlocProvider(create: (context) => CategoryListBloc(repository: Repository()), ),
        BlocProvider(create: (context) => FeaturedNewsBloc(repository: Repository())),
        BlocProvider(create: (context) => LiveVideoBloc(repository: Repository()),
        ),
      ],
    ),
    // AdListView(),

    BlocProvider<CategoryListBloc>(
        create: (context) => CategoryListBloc(repository: Repository()),
        child: const CategoryListScreen()
    ),

    SavedNewsScreen(),
    MoreScreen()
  ];

  void onTabTapped(int index) {
    if(index==2){
      FavoritesProvider _favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
      _favoritesProvider.getFeed();
    }
    setState(() {
      _page = index;
    });
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exitDialog(context),
      child: Scaffold(
        body: IndexedStack(index:_page ,
            children:[
              _children[0],
              _children[1],
              _children[2],
              _children[3]
            ]),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).backgroundColor,
          selectedItemColor: redColor,
          unselectedItemColor: Colors.grey[500],
          elevation: 20,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: ("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: ("Categories"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.push_pin),
              label: ("Saved"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_vert_rounded),
              label:("More"),
            ),
          ],
          onTap: onTabTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  exitDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 15),
              Text( Constants.appName,
                style:TextStyle( fontWeight: FontWeight.bold, fontSize: 20, color: Theme.of(context).textTheme.bodyText1!.color),
              ),

              const  SizedBox(height: 25),

               Text( "Do you really want to exit?",
                style: TextStyle( fontWeight: FontWeight.w500, fontSize: 18, color: Theme.of(context).textTheme.bodyText1!.color),
              ),

              const   SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    width: 80,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        side: BorderSide(color: redColor),
                      ),

                      child: const Text( "Yes",
                        style: TextStyle( color: redColor, fontSize: 16),
                      ),
                      onPressed: ()=> exit(0),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 40,
                    width: 80,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: redColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),

                      child: Text( "No",
                        style: TextStyle( color: whiteColor, fontSize: 16,),
                      ),
                      onPressed: ()=>Navigator.pop(context),
                      // color: Colors.white,
                    ),
                  ),
                ],
              ),
             const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


