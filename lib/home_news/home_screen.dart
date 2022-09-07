
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:punch_ios_android/category_list/bloc.dart';
import 'package:punch_ios_android/category_list/event.dart';
import 'package:punch_ios_android/category_list/model.dart';
import 'package:punch_ios_android/category_list/state.dart';
import 'package:punch_ios_android/home_news/home_bloc.dart';
import 'package:punch_ios_android/home_news/home_event.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/home_news/home_state.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_bloc.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_screen.dart';
import 'package:punch_ios_android/news_tag/news_tag_bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/screens/news_details.dart';
import 'package:punch_ios_android/search_result/search_result.dart';
import 'package:punch_ios_android/search_result/search_result_bloc.dart';
import 'package:punch_ios_android/utility/app_provider.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/utility/constants.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:punch_ios_android/widgets/build_error_ui.dart';
import 'package:punch_ios_android/widgets/build_loading_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



class HomeNewsScreen extends StatefulWidget {
  const HomeNewsScreen({Key? key}) : super(key: key);

  @override
  _HomeNewsScreenState createState() => _HomeNewsScreenState();
}

class _HomeNewsScreenState extends State<HomeNewsScreen> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  late HomeNewsBloc homeNewsBloc;
  late Repository repository;
  late HomeNewsModel homeModel;
  late CategoryListBloc categoryListBloc;
  late CategoryListModel categoryListModel;
  late RefreshController refreshController;
  late FontSizeController _fontSizeController;
  late StreamSubscription _subscription;
  late AppProvider?  _appProvider;
  final String _searchQuery= 'a';
  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  final ScrollController _sc =  ScrollController();

  double _height =0;

  // for the refresh action
  bool isRefreshing=false;
  bool darkTheme = false;
  bool isSaved = false;

  // pagination
  List<HomeNewsModel> allHomeNews = [];
  int currentPage = 1;
  bool isLoadingMore = false;

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.largeBanner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  final BannerAd secondBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.largeBanner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  void loadMore() {
    // make sure that it is not already loading
    if(isLoadingMore==false) {
      // show the loading indicator
      setState ( (
          ) {
        isLoadingMore=true;
      } );

      homeNewsBloc.add ( FetchMoreHomeNewsEvent ( page: currentPage + 1 ) );
    }
  }

  setRefreshing(bool state){
    setState(() {
      isRefreshing = state;
    });
    if(state==false){
      _refreshController.refreshCompleted();
    }
  }

  void refresh(){
    setState(() {
      isRefreshing =true;
      currentPage = 1;
    });
    homeNewsBloc.add(RefreshHomeNewsEvent());
  }

  @override
  void initState() {
    super.initState();
    _fontSizeController = Provider.of<FontSizeController>(context, listen: false);
    homeNewsBloc = BlocProvider.of<HomeNewsBloc>(context);
    homeNewsBloc.add(FetchHomeNewsEvent());

    categoryListBloc = BlocProvider.of<CategoryListBloc>(context);
    categoryListBloc.add(FetchCategoryListEvent());

    _appProvider = Provider.of<AppProvider>(context, listen: false);

    myBanner.load();
    secondBanner.load();

  }

  @override
  Widget build( context) {
    return   Consumer<FontSizeController>(
        builder: ( context,  fontScale, child) {
          return Scaffold (
            key: scaffoldState,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar (
              centerTitle: true ,
              title: Image.asset ( 'assets/punchLogo.png' , width: 100 , height: 40 ) ,
              actions: [
//          IconButton(
//              icon: Icon(Icons.refresh,size: 30,color: Colors.grey[400],),
//              padding: EdgeInsets.all(5),
//              onPressed: () async{
//                await FlutterFundingChoices.showConsentForm();
//                await refreshConsentInfo();
//                },
//
//            )
              ],
            ) ,
            body: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: _refreshController,
              onRefresh: refresh,
              footer: CustomFooter(
                builder: ( context, mode){
                  Widget body ;
                  if(isLoadingMore == false){
                    body =  const Text("No more news");
                    print("current status of is loading more :" + isLoadingMore.toString());
                  }
                  else {
                    body =  const SizedBox(child: CircularProgressIndicator(color: mainColor,),height: 30,width: 30);
                  }

                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    height: 55.0,
                    child: Center(child:body),
                  );
                },
              ),
              header: const ClassicHeader(),
              onLoading: loadMore,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Theme.of(context).backgroundColor,
                      child: BlocListener<HomeNewsBloc, HomeNewsState>(
                        listener: (context, state){
                          if ( state is HomeNewsRefreshingState ) {
                            setRefreshing(true);
                          }
                          else if ( state is HomeNewsRefreshedState ) {

                            setState(() {
                              currentPage = 1;
                              isRefreshing = false;
                              _refreshController.refreshCompleted();
                              allHomeNews.clear();
                              allHomeNews = state.homeNews;
                            });
                          }
                          else if ( state is HomeNewsLoadedState ) {
                            setState(() {
                              currentPage = 1;
                              isRefreshing = false;
                              _refreshController.refreshCompleted();
                              allHomeNews = state.homeNews;
                            });

                          }
                          else if ( state is HomeNewsMoreLoadedState ) {
                            setState(() {
                              currentPage ++;
                              isLoadingMore = false;
                              _refreshController.loadComplete();
                              allHomeNews.addAll(state.homeNews) ;
                            });
                          }
                          else if ( state is HomeNewsMoreFailureState ) {
                            setState(() {
                              isLoadingMore = false;
                            });

                          }
                          else if ( state is HomeNewsLoadFailureState ) {
                            setRefreshing(false);
                          }else{
                            setRefreshing(false);
                          }
                        },
                        child: BlocBuilder<HomeNewsBloc, HomeNewsState>(
                          buildWhen:(previous,current){
                            // returning false here when we have a load failure state means that.
                            // we do not want the widget to rebuild when there is error
                            if(current is HomeNewsLoadFailureState || current is HomeNewsRefreshingState || current is HomeNewsMoreLoadedState
                                || current is HomeNewsMoreFailureState || current is HomeNewsLoadingMoreState ) {
                              return false;
                            }  else {
                              return true;
                            }
                          },
                          builder: (context, state) {
                            if ( state is InitialState ) {
                              return const BuildLoadingWidget ( );
                            } else if ( state is HomeNewsLoadingState ) {
                              return const BuildLoadingWidget ( );
                            } else if ( state is HomeNewsLoadedState ) {
                              return buildHomeNewsList ( allHomeNews );
                            }
                            else if ( state is HomeNewsRefreshedState ) {
                              return buildHomeNewsList ( allHomeNews );
                            }
                            else if ( state is HomeCachedNewsLoadedState ) {
                              return buildHomeCachedNews ( state.cachedNews );
                            }
                            else if ( state is HomeNewsLoadFailureState ) {
                              return BuildErrorUi (message: state.error );
                            }
                            else {
                              return const BuildErrorUi (message: "Something went wrong!" );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }


//HOME NEWS
  Widget buildHomeNewsList (List<HomeNewsModel> homeNewsModel){
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final AdWidget secondWidget = AdWidget(ad: secondBanner);

    return  ListView.separated (
        padding: EdgeInsets.symmetric ( horizontal: 7 ) ,
        scrollDirection: Axis.vertical ,
        itemCount: homeNewsModel.length+1,
        shrinkWrap: true ,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, pos) {
          if(pos == homeNewsModel.length) {
            return Visibility(
              visible: false,
              child: Container(
                margin: EdgeInsets.all(10),
                height: 40,
                width: 130,
              ),
            );
          } else {
            return Padding (
              padding: const EdgeInsets.symmetric (vertical: 0 ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  onTap: (){
                    HomeNewsModel lNM = homeNewsModel[pos];
                    Navigator.push ( context , 
                        MaterialPageRoute(builder: (context) =>  BlocProvider<NewsTagBloc> (
                        create: (context) => NewsTagBloc (repository: Repository ()) ,
                        child: NewsDetails ( newsModel: lNM , )
                    ) , )
                   
                    
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all( Radius.circular(10), ),
                        ),
                        elevation: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all( Radius.circular(10)),
                          child: Hero(
                            tag: pos,
                            child: CachedNetworkImage(
                              //imageUrl: "$img",
                              imageUrl: '${homeNewsModel[pos].xFeaturedMedia}',
                              placeholder: (context, url) => Container(
                                  height: 125,
                                  width: 248,
                                  child: Center(child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/punchLogo.png",
                                fit: BoxFit.contain,
                                // height: 100,
                                // width: 100,
                              ),
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                      ),

                      SizedBox( width: 10),

                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Material(
                              type: MaterialType.transparency,
                              child: Html(
                                data: '${homeNewsModel[pos].title!.rendered}',
                                useRichText: true,
                                renderNewlines: true,
                                defaultTextStyle: TextStyle(
                                    color: Theme.of(context).textTheme.bodyText1.color,
                                    fontSize:8*_fontSizeController.value,fontWeight:FontWeight.w500),
                              ),
                            ),
                            SizedBox( height: 10),
                            Row(
                              children: <Widget>[
                                Container(
                                  constraints: BoxConstraints( maxWidth: 150),
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Theme.of(context).accentColor,
                                  ),
                                  child: GestureDetector (
                                    onTap: () {
                                      // CategoryListModel cLM = categoryListModel[pos];
                                      CategoryListModel cLM = CategoryListModel ( );
                                      cLM.categoryId = homeNewsModel[pos].categories[0].toString ( );
                                      cLM.categoryName = homeNewsModel[pos].categoriesString[0];

                                      Navigator.push ( context , MaterialPageRoute(builder: (context)=>BlocProvider<NewsByCategoryBloc> (
                                          create: (context) => NewsByCategoryBloc (newsByCategoryRepository: NewsRepository ()) ,
                                          child: NewsByCategory ( model: cLM , )
                                        ) , 
                                       )
                                      );
                                    } ,
                                    child: Text (
                                      '${ homeNewsModel[pos].categoriesString[0].replaceAll("&amp;", "&")}' ,
                                      // "${newsByCategoryModel.xCategories}",
                                      style: TextStyle ( fontSize: 5*_fontSizeController.value , color: Colors.white ,
                                      ) ,
                                    ) ,
                                  ) ,
                                ),
                                Spacer(),

                                Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                      Constants.readTimestamp(homeNewsModel[pos].date),
                                      style: TextStyle( fontSize: 4*_fontSizeController.value , color:Theme.of(context).textTheme.bodyText1.color)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            );
          }
        } ,

        separatorBuilder: ( context, index) {
          return index != 2 && index % 6 == 0
              ? Container(
            margin: EdgeInsets.symmetric( vertical: 5),
            child: Visibility(
              visible:true,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  // decoration: BoxDecoration(
                  //   color: Theme.of(context).primaryColor.withOpacity(0.7),
                  //   borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(10),
                  //     topRight: Radius.circular(10),
                  //   ),
                  //   boxShadow: [
                  //     BoxShadow(
                  //         color: Theme.of(context).focusColor.withOpacity(0.1),
                  //         blurRadius: 5,
                  //         offset: Offset(0, 2)),
                  //   ],
                  // ),
                  // hiding: change the value here to _height
                  height: _height,
                  child: NativeAdmob(
                    adUnitID: AdHelper.homeNative,
                    controller: _nativeAdController,
                    type: NativeAdmobType.full,
                    options: NativeAdmobOptions(
                      adLabelTextStyle: NativeTextStyle(color:Theme.of(context).textTheme.bodyText1.color),
                      advertiserTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                      headlineTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                      // bodyTextStyle: NativeTextStyle(color: Theme.of(context).textTheme.bodyText2.color),
                    ),
                  )

              ),
            ),
          )
              : Container(height: 10);
        }

    );
  }

  //FOR HOME CACHED NEWS
  Widget buildHomeCachedNews (List<HomeNewsModel> homeNewsModel){
    return ListView.builder (
      padding: EdgeInsets.symmetric ( horizontal: 10 ) ,
      scrollDirection: Axis.vertical ,
      itemCount: homeNewsModel.length,
      shrinkWrap: true ,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, pos) {
        String cat = homeNewsModel[pos].categoriesString.toString ();

        return Padding (
          padding: EdgeInsets.symmetric (vertical: 5 ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).focusColor.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2)),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              onTap: (){
                NewsModel lNM = homeNewsModel[pos];
                Navigator.push ( context ,
                  PageTransition (
                    type: PageTransitionType.rightToLeft ,
                    child: BlocProvider<NewsTagBloc> (
                        create: (context) => NewsTagBloc (newsTagRepository: NewsRepository ()) ,
                        child: NewsDetails ( newsModel: lNM , )
                    ) ,
                  ) ,
                );

              },
              child: Row(
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all( Radius.circular(10), ),
                    ),
                    elevation: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all( Radius.circular(10)),
                      child: Hero(
                        tag: pos,
                        child: CachedNetworkImage(
                          //imageUrl: "$img",
                          imageUrl: '${homeNewsModel[pos].xFeaturedMedia}',
                          placeholder: (context, url) => Container(
                              height: 125,
                              width: 248,
                              child: Center(child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/punchLogo.png",
                            fit: BoxFit.contain,
                            // height: 100,
                            // width: 100,
                          ),
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),

                  SizedBox( width: 10),

                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Material(
                          type: MaterialType.transparency,
                          child: Html(
                            data: '${homeNewsModel[pos].title.rendered}',
                            useRichText: true,
                            renderNewlines: true,
                            defaultTextStyle: TextStyle(color:  Theme.of(context).textTheme.bodyText1.color, fontSize: 8*_fontSizeController.value,fontWeight:FontWeight.w500),
                          ),
                        ),
                        SizedBox( height: 10),
                        Row(
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints( maxWidth: 150),
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).accentColor,
                              ),
                              child: GestureDetector (
                                onTap: () {
                                  // CategoryListModel cLM = categoryListModel[pos];
                                  CategoryListModel cLM = CategoryListModel ( );
                                  cLM.categoryId = homeNewsModel[pos].categories[0].toString ( );
                                  cLM.categoryName = homeNewsModel[pos].categoriesString[0];

                                  Navigator.push ( context ,
                                    PageTransition (
                                      type: PageTransitionType.rightToLeft ,
                                      child: BlocProvider<NewsByCategoryBloc> (
                                          create: (context) => NewsByCategoryBloc (newsByCategoryRepository: NewsRepository ()) ,
                                          child: NewsByCategory ( model: cLM , )
                                      ) ,
                                    ) ,
                                  );
                                } ,
                                child: Text (
                                  '${ homeNewsModel[pos].categoriesString[0].replaceAll("&amp;", "&")}' ,
                                  // "${newsByCategoryModel.xCategories}",
                                  style: TextStyle ( fontSize: 5*_fontSizeController.value , color: Colors.white ,
                                  ) ,
                                ) ,
                              ) ,
                            ),
                            Spacer(),

                            Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                  Constants.readTimestamp(homeNewsModel[pos].date),
                                  style: TextStyle( fontSize:4*_fontSizeController.value, color:  Theme.of(context).textTheme.bodyText1.color, )),
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } ,
    );

  }
  
  
}
