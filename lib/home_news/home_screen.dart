import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:jiffy/jiffy.dart';
import 'package:punch_ios_android/category_list/bloc.dart';
import 'package:punch_ios_android/category_list/event.dart';
import 'package:punch_ios_android/category_list/model.dart';
import 'package:punch_ios_android/featured_news/featured_news_bloc.dart';
import 'package:punch_ios_android/featured_news/featured_news_state.dart';
import 'package:punch_ios_android/home_news/home_bloc.dart';
import 'package:punch_ios_android/home_news/home_event.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/home_news/home_state.dart';
import 'package:punch_ios_android/live_video/live_video_bloc.dart';
import 'package:punch_ios_android/live_video/live_video_model.dart';
import 'package:punch_ios_android/live_video/live_video_response.dart';
import 'package:punch_ios_android/live_video/live_video_state.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_bloc.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_screen.dart';
import 'package:punch_ios_android/news_tag/news_tag_bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/screens/news_details.dart';
import 'package:punch_ios_android/utility/app_provider.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:punch_ios_android/widgets/build_error_ui.dart';
import 'package:punch_ios_android/widgets/build_loading_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart' as navigation;
import 'package:http/http.dart' as http;


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
  // late FeaturedNewsBloc featuredNewsBloc;
  late CategoryListModel categoryListModel;
  late RefreshController refreshController;
  late FontSizeController fontSizeController;
  late StreamSubscription subscription;
  late AppProvider? appProvider;
  final String searchQuery = 'a';
  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  final ScrollController sc = ScrollController();
  final double height = 0;

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading=true;
  final _key = UniqueKey();

  final  httpClient = http.Client();


  // for the refresh action
  bool isRefreshing = false;
  bool darkTheme = false;
  bool isSaved = false;

  // pagination
  List<HomeNewsModel> allHomeNews = [];
  int currentPage = 1;
  bool isLoadingMore = false;

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.largeBanner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  final BannerAd secondBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.largeBanner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  void loadMore() {
    // make sure that it is not already loading
    if (isLoadingMore == false) {
      // show the loading indicator
      setState(() {
        isLoadingMore = true;
      });

      homeNewsBloc.add(FetchMoreHomeNewsEvent(page: currentPage + 1));
    }
  }

  setRefreshing(bool state) {
    setState(() {
      isRefreshing = state;
    });
    if (state == false) {
      _refreshController.refreshCompleted();
    }
  }

  void refresh() {
    setState(() {
      isRefreshing = true;
      currentPage = 1;
    });
    homeNewsBloc.add(RefreshHomeNewsEvent());
    // featuredNewsBloc.add(FetchFeaturedNewsEvent());
  }

  List<LiveVideoModel> liveVideoModel = <LiveVideoModel>[];

  //API CALL
  Future<List<LiveVideoModel>>fetchLiveVideo() async {

    final response = await httpClient.get(Uri.parse("https://punchng.com/mobile-app-streaming/"));

    // print("live video url from screen - " + "https://punchng.com/mobile-app-streaming/");
    // print("live video from screen" + response.body);

    var data = json.decode(response.body);
    liveVideoModel=(json.decode(response.body) as List).map((i) => LiveVideoModel.fromJson(i)).toList();
    setState(() {});

    // print("length data " + data.length.toString());
    // print("length streaming value " + liveVideoModel[0].streaming.toString());
    // print("length live video model " + liveVideoModel.length.toString());
    //

    /// Tells to Flutter that now something has changed
    // print("live video from screen length "+ liveVideoModel.length.toString());

    LiveVideoResponse liveVideo = LiveVideoResponse.fromJson(data);
    return liveVideo.liveVideos;
  }

  @override
  void initState() {
    super.initState();
    fontSizeController = Provider.of<FontSizeController>(context, listen: false);
    homeNewsBloc = BlocProvider.of<HomeNewsBloc>(context);
    homeNewsBloc.add(FetchHomeNewsEvent());

    categoryListBloc = BlocProvider.of<CategoryListBloc>(context);
    categoryListBloc.add(FetchCategoryListEvent());

    // featuredNewsBloc = BlocProvider.of<FeaturedNewsBloc>(context);
    // featuredNewsBloc.add(FetchFeaturedNewsEvent());

    appProvider = Provider.of<AppProvider>(context, listen: false);

    myBanner.load();
    secondBanner.load();
  }

  @override
  Widget build(context) {
    return Consumer<FontSizeController>(builder: (context, fontScale, child) {
      return Scaffold(
        key: scaffoldState,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset('assets/punchLogo.png', width: 100, height: 40),
        ),
        body: liveVideoModel.isNotEmpty && liveVideoModel[0].streaming == true

            ? liveVideoHomeScreen()
            :mainHomeScreen()

        // body: SmartRefresher(
        //   enablePullDown: true,
        //   enablePullUp: true,
        //   controller: _refreshController,
        //   onRefresh: refresh,
        //   footer: CustomFooter(
        //     builder: (context, mode) {
        //       Widget body;
        //       if (isLoadingMore == false) {
        //         body = const Text("No more news");
        //         print("current status of is loading more :" +
        //             isLoadingMore.toString());
        //       } else {
        //         body = const SizedBox(
        //             child: CircularProgressIndicator(
        //               color: mainColor,
        //             ),
        //             height: 30,
        //             width: 30);
        //       }
        //
        //       return Container(
        //         color: Theme.of(context).scaffoldBackgroundColor,
        //         height: 55.0,
        //         child: Center(child: body),
        //       );
        //     },
        //   ),
        //   header: const ClassicHeader(),
        //   onLoading: loadMore,
        //   child: SingleChildScrollView(
        //     child: Column(
        //       children: [
        //
        //         //LATEST NEWS
        //         Container(
        //           color: Theme.of(context).backgroundColor,
        //           child: Column(
        //             children: [
        //               Padding(
        //                 padding: const EdgeInsets.fromLTRB(8.0, 10.0, 0.0, 0.0),
        //                 child: Container(
        //                   margin:const EdgeInsets.symmetric(horizontal: 5),
        //                   // color: Colors.white,
        //                   width: MediaQuery.of(context).size.width,
        //                   child: Text(
        //                     "LATEST NEWS",
        //                     style: TextStyle(
        //                         color: Theme.of(context)
        //                             .textTheme
        //                             .bodyText1!
        //                             .color,
        //                         fontSize: 16.5,
        //                         fontWeight: FontWeight.bold,
        //                         letterSpacing: 1),
        //                   ),
        //                 ),
        //               ),
        //               BlocListener<HomeNewsBloc, HomeNewsState>(
        //                 listener: (context, state) {
        //                   if (state is HomeNewsRefreshingState) {
        //                     setRefreshing(true);
        //                   } else if (state is HomeNewsRefreshedState) {
        //                     setState(() {
        //                       currentPage = 1;
        //                       isRefreshing = false;
        //                       _refreshController.refreshCompleted();
        //                       allHomeNews.clear();
        //                       allHomeNews = state.homeNews;
        //                     });
        //                   } else if (state is HomeNewsLoadedState) {
        //                     setState(() {
        //                       currentPage = 1;
        //                       isRefreshing = false;
        //                       _refreshController.refreshCompleted();
        //                       allHomeNews = state.homeNews;
        //                     });
        //                   } else if (state is HomeNewsMoreLoadedState) {
        //                     setState(() {
        //                       currentPage++;
        //                       isLoadingMore = false;
        //                       _refreshController.loadComplete();
        //                       allHomeNews.addAll(state.homeNews);
        //                     });
        //                   } else if (state is HomeNewsMoreFailureState) {
        //                     setState(() {
        //                       isLoadingMore = false;
        //                     });
        //                   } else if (state is HomeNewsLoadFailureState) {
        //                     setRefreshing(false);
        //                   } else {
        //                     setRefreshing(false);
        //                   }
        //                 },
        //                 child: BlocBuilder<HomeNewsBloc, HomeNewsState>(
        //                   buildWhen: (previous, current) {
        //                     // returning false here when we have a load failure state means that.
        //                     // we do not want the widget to rebuild when there is error
        //                     if (current is HomeNewsLoadFailureState ||
        //                         current is HomeNewsRefreshingState ||
        //                         current is HomeNewsMoreLoadedState ||
        //                         current is HomeNewsMoreFailureState ||
        //                         current is HomeNewsLoadingMoreState) {
        //                       return false;
        //                     } else {
        //                       return true;
        //                     }
        //                   },
        //                   builder: (context, state) {
        //                     if (state is InitialState) {
        //                       return const BuildLoadingWidget();
        //                     } else if (state is HomeNewsLoadingState) {
        //                       return const BuildLoadingWidget();
        //                     } else if (state is HomeNewsLoadedState) {
        //                       return buildHomeNewsList(allHomeNews);
        //                     } else if (state is HomeNewsRefreshedState) {
        //                       return buildHomeNewsList(allHomeNews);
        //                     } else if (state is HomeCachedNewsLoadedState) {
        //                       return buildHomeCachedNews(state.cachedNews);
        //                     } else if (state is HomeNewsLoadFailureState) {
        //                       return BuildErrorUi(message: state.error);
        //                     } else {
        //                       return const BuildErrorUi(
        //                           message: "Something went wrong!");
        //                     }
        //                   },
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      );
    });
  }


  //Main Home Screen(without live video)
  Widget mainHomeScreen(){
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: refresh,
      footer: CustomFooter(
        builder: ( context, mode){
          Widget body ;
          if(isLoadingMore == false){
            body =  Text("loading more ....");
            // print("current status of is loading more :" + isLoadingMore.toString());
          }
          else {
            body =  SizedBox(child: CircularProgressIndicator(),height: 30,width: 30);
          }

          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 55.0,
            child: Center(child:body),
          );
        },
      ),
      header: ClassicHeader(),
      onLoading: loadMore,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              child: BlocListener <FeaturedNewsBloc, FeaturedNewsState>(
                  listener: (context, state){
                    if ( state is FeaturedNewsRefreshingState ) {

                    } else if ( state is FeaturedNewsLoadedState ) {

                    }else if ( state is FeaturedCachedNewsLoadedState  ) {
                      // a message will only come when it is updating the feed.
                    }
                    else if ( state is FeaturedNewsLoadFailureState ) {

                    }
                  },

                  child: BlocBuilder<FeaturedNewsBloc, FeaturedNewsState>(
                    buildWhen:(previous,current){
                      // returning false here when we have a load faliure state means that.
                      // we do not want the widget to rebuild when there is error
                      if(current is FeaturedNewsLoadFailureState)
                        return false;
                      else
                        return true;
                    },
                    builder: (context, state) {
                      if ( state is FeaturedNewsInitialState ) {
                        return Container(
                        );
                      } else if ( state is FeaturedNewsLoadingState ) {
                        return  Container(
                        );

                      } else if ( state is FeaturedNewsLoadedState ) {
                        return Container(
                            child: imageSlider( state.featuredNews));
                        // return buildFeaturedNewsList ( state.featuredNews);
                      }else if ( state is FeaturedCachedNewsLoadedState ) {
                        return Container(
                            child: imageSliderCached( state.featuredNews));
                        // return buildFeaturedNewsList ( state.featuredNews);
                      }  else if ( state is FeaturedNewsLoadFailureState ) {
                        return BuildErrorUi (message: state.error );
                      }
                      else {
                        return BuildErrorUi (message: "Something went wrong!" );
                      }
                    },
                  )

              ),
            ),

            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 10.0, 0.0, 0.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      // color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Text( "LATEST NEWS",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 16.5, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ),
                  ),

                  BlocListener<HomeNewsBloc, HomeNewsState>(
                    listener: (context, state){
                      if ( state is HomeNewsRefreshingState ) {
                        setRefreshing(true);
                      }
                      else if ( state is HomeNewsRefreshedState ) {
                        // Scaffold.of ( context ).showSnackBar ( SnackBar (
                        //   content: Text ( "News Updated" ) , ) );
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
                          // Scaffold.of ( context ).showSnackBar ( SnackBar (
                          //   content: Text ( "Could not fetch more news at this time" ) , ) );
                        });
                      }
                      else if ( state is HomeNewsLoadFailureState ) {
                        // Scaffold.of ( context ).showSnackBar ( SnackBar (
                        //   content: Text ( "Could not load Home news at this time" ) , ) );
                        setRefreshing(false);
                      }else{
                        setRefreshing(false);
                      }
                    },
                    child: BlocBuilder<HomeNewsBloc, HomeNewsState>(
                      buildWhen:(previous,current){
                        // returning false here when we have a load failure state means that.
                        // we do not want the widget to rebuild when there is error
                        if(current is HomeNewsLoadFailureState || current is HomeNewsRefreshingState || current is HomeNewsMoreLoadedState || current is HomeNewsMoreFailureState || current is HomeNewsLoadingMoreState )
                          return false;
                        else
                          return true;
                      },
                      builder: (context, state) {
                        if ( state is InitialState ) {
                          return BuildLoadingWidget ( );
                        } else if ( state is HomeNewsLoadingState ) {
                          return BuildLoadingWidget ( );
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
                          return BuildErrorUi (message: "Something went wrong!" );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Home screen for live video
  Widget liveVideoHomeScreen(){
    return Column(
      children: [
        Container(
          // height: 300, was here
          child: BlocListener <LiveVideoBloc, LiveVideoState>(
              listener: (context, state){
                if ( state is LiveVideoRefreshingState ) {

                } else if ( state is LiveVideoLoadedState ) {

                }
                else if ( state is LiveVideoLoadFailureState ) {

                }
              },

              child: BlocBuilder<LiveVideoBloc, LiveVideoState>(
                buildWhen:(previous,current){
                  // returning false here when we have a load faliure state means that.
                  // we do not want the widget to rebuild when there is error
                  if(current is LiveVideoLoadFailureState)
                    return false;
                  else
                    return true;
                },
                builder: (context, state) {
                  if ( state is LiveVideoInitialState ) {
                    return Container(
                    );
                  } else if ( state is LiveVideoLoadingState ) {
                    return  Container(
                    );

                  } else if ( state is LiveVideoLoadedState ) {
                    return Container(
                        child: liveVideo( state.liveVideo));
                  }  else if ( state is LiveVideoLoadFailureState ) {
                    return BuildErrorUi (message: state.error );
                  }
                  else {
                    return BuildErrorUi (message: "Something went wrong!" );
                  }
                },
              )

          ),
        ),

        Expanded(
          flex:1,
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: _refreshController,
            onRefresh: refresh,
            footer: CustomFooter(
              builder: ( context, mode){
                Widget body ;
                if(isLoadingMore == false){
                  body =  Text("loading more ....");
                  // print("current status of is loading more :" + isLoadingMore.toString());
                }
                else {
                  body =  SizedBox(child: CircularProgressIndicator(),height: 30,width: 30);
                }

                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: 55.0,
                  child: Center(child:body),
                );
              },
            ),
            header: ClassicHeader(),
            onLoading: loadMore,
            child: SingleChildScrollView(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 10.0, 0.0, 0.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        // color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        child: Text( "LATEST NEWS",
                          style: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: 16.5, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                    ),

                    BlocListener<HomeNewsBloc, HomeNewsState>(
                      listener: (context, state){
                        if ( state is HomeNewsRefreshingState ) {
                          setRefreshing(true);
                        }
                        else if ( state is HomeNewsRefreshedState ) {
                          // Scaffold.of ( context ).showSnackBar ( SnackBar (
                          //   content: Text ( "News Updated" ) , ) );
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
                            // Scaffold.of ( context ).showSnackBar ( SnackBar (
                            //   content: Text ( "Could not fetch more news at this time" ) , ) );
                          });
                        }
                        else if ( state is HomeNewsLoadFailureState ) {
                          // Scaffold.of ( context ).showSnackBar ( SnackBar (
                          //   content: Text ( "Could not load Home news at this time" ) , ) );
                          setRefreshing(false);
                        }else{
                          setRefreshing(false);
                        }
                      },
                      child: BlocBuilder<HomeNewsBloc, HomeNewsState>(
                        buildWhen:(previous,current){
                          // returning false here when we have a load failure state means that.
                          // we do not want the widget to rebuild when there is error
                          if(current is HomeNewsLoadFailureState || current is HomeNewsRefreshingState || current is HomeNewsMoreLoadedState || current is HomeNewsMoreFailureState || current is HomeNewsLoadingMoreState )
                            return false;
                          else
                            return true;
                        },
                        builder: (context, state) {
                          if ( state is InitialState ) {
                            return BuildLoadingWidget ( );
                          } else if ( state is HomeNewsLoadingState ) {
                            return BuildLoadingWidget ( );
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
                            return BuildErrorUi (message: "Something went wrong!" );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  //FOR LIVE VIDEO
  Widget liveVideo(List<LiveVideoModel> liveVideoModel){
    // print("live video status  - " + liveVideoModel[0].status);
    // print ("live Video streaming - " + liveVideoModel[0].streaming.toString());
    // print ("live Video list2 - " + liveVideoModel.length.toString());

    return  ClipRRect(
        child: Column(
          children: [
            Container(
              height: 220,
              child: Stack(
                children: [
                  WebView (
                    key: _key,
                    initialUrl: liveVideoModel[0].data!.url,
                    javascriptMode: JavascriptMode.unrestricted ,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete ( webViewController );
                    } ,
                    navigationDelegate: (navigation.NavigationRequest request) {
//                         if (request.url.startsWith('https://www.youtube.com/')) {
//                           return NavigationDecision.prevent;
//                         }
                      return navigation.NavigationDecision.navigate;
                    } ,
                    onPageStarted: (String url) {
                      setState(() {
                        isLoading = true;
                      });
                    } ,
                    onPageFinished: (String url) {
                      setState(() {
                        isLoading = false;
                      });
                    } ,
                    gestureNavigationEnabled: false ,
                    initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow ,
                  ),
                  isLoading ? Center( child: CircularProgressIndicator(),)
                      : Stack(),
                ],
              ),
            ),

            Center(
              child:
              Padding(
               padding: EdgeInsets.only(left: 5.0),
                child: Html(
                  data: '${liveVideoModel[0].data!.title} ',
                  style: {
                    "body": Style(
                        fontSize: const FontSize(18.0),
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color),
                  },
                ),
              )
              // Html(
              //   padding: EdgeInsets.only(left: 5.0),
              //   data: '${liveVideoModel[0].data.title} ',
              //   useRichText: true,
              //   renderNewlines: true,
              //   defaultTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color,
              //       fontSize: 23,fontWeight:FontWeight.bold),
              // ),
            ),

            Divider(color: Theme.of(context).textTheme.bodyText1!.color,),
          ],
        )
    );

  }



  //HOME NEWS..LATEST NEWS
  Widget buildHomeNewsList(List<HomeNewsModel> homeNewsModel) {
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final AdWidget secondWidget = AdWidget(ad: secondBanner);

    return ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 7,
        ),
        scrollDirection: Axis.vertical,
        itemCount: homeNewsModel.length + 1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (ctx, pos) {
          if (pos == homeNewsModel.length) {
            return Visibility(
              visible: false,
              child: Container(
                margin: const EdgeInsets.all(15),
                height: 40,
                width: 130,
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).focusColor.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: InkWell(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                onTap: () {
                  HomeNewsModel lNM = homeNewsModel[pos];
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider<NewsTagBloc>(
                            create: (context) =>
                                NewsTagBloc(repository: Repository()),
                            child: NewsDetails(
                              newsModel: lNM,
                            )),
                      ));
                },
                child: Row(
                  children: <Widget>[
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      elevation: 4,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: Hero(
                          tag: pos,
                          child: CachedNetworkImage(
                            imageUrl: '${homeNewsModel[pos].xFeaturedMedia}',
                            placeholder: (context, url) => SizedBox(
                                height: 125,
                                width: 248,
                                child: Center(
                                    child: CircularProgressIndicator(
                                        color: Theme.of(context).primaryColor))),
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
                    const SizedBox(width: 10),
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
                                style: {
                                  "body": Style(
                                      fontSize: const FontSize(18.0),
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color),
                                },
                              )),
                          const SizedBox(height: 10),
                          Row(
                            children: <Widget>[
                              Container(
                                constraints: const BoxConstraints(maxWidth: 150),
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: redColor,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    CategoryListModel cLM = CategoryListModel();
                                    cLM.id = homeNewsModel[pos].categories![0].toString();
                                    cLM.categoryName = homeNewsModel[pos].categoriesString![0];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider<NewsByCategoryBloc>(
                                                  create: (context) =>
                                                      NewsByCategoryBloc(
                                                          repository:
                                                              Repository()),
                                                  child: NewsByCategory(
                                                    model: cLM,
                                                  )),
                                        ));
                                  },
                                  child: Text(
                                    homeNewsModel[pos].categoriesString![0].replaceAll("&amp;", "&"),
                                    style: TextStyle(
                                      fontSize: 4.5 * fontSizeController.value,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  Jiffy('${homeNewsModel[pos].date}').fromNow(),
                                    style: TextStyle(
                                        fontSize: 4 * fontSizeController.value,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        separatorBuilder: (context, index) {
          return index % 5 == 0
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: index % 10 == 0
                      ?
                      SizedBox(child: adWidget, height: 100,)
                      // Container(color: Colors.black12, height: 120)

                      :  SizedBox( child: secondWidget , height: 100, )
                      // : Container(color: Colors.black12, height: 120)
          )
              : Container(height: 10);
        });
  }

  //FOR HOME CACHED NEWS..LATEST NEWS
  Widget buildHomeCachedNews(List<HomeNewsModel> homeNewsModel) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      scrollDirection: Axis.vertical,
      itemCount: homeNewsModel.length + 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, pos) {
        if (pos == homeNewsModel.length) {
          return Visibility(
            visible: false,
            child: Container(
              margin: const EdgeInsets.all(15),
              height: 40,
              width: 130,
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).focusColor.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: InkWell(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              onTap: () {
                HomeNewsModel lNM = homeNewsModel[pos];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<NewsTagBloc>(
                          create: (context) =>
                              NewsTagBloc(repository: Repository()),
                          child: NewsDetails(
                            newsModel: lNM,
                          )),
                    ));
              },
              child: Row(
                children: <Widget>[
                  Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    elevation: 4,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Hero(
                        tag: pos,
                        child: CachedNetworkImage(
                          imageUrl: '${homeNewsModel[pos].xFeaturedMedia}',
                          placeholder: (context, url) => SizedBox(
                              height: 125,
                              width: 248,
                              child: Center(
                                  child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor))),
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
                  const SizedBox(width: 10),
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
                              style: {
                                "body": Style(
                                    fontSize: const FontSize(18.0),
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).textTheme.bodyText1!.color),
                              },
                            )),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: redColor,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  CategoryListModel cLM = CategoryListModel();
                                  cLM.id = homeNewsModel[pos].categories![0].toString();
                                  cLM.categoryName = homeNewsModel[pos].categoriesString![0];

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider<NewsByCategoryBloc>(
                                                create: (context) =>
                                                    NewsByCategoryBloc(
                                                        repository:
                                                            Repository()),
                                                child: NewsByCategory(
                                                  model: cLM,
                                                )),
                                      ));
                                },
                                child: Text(
                                  homeNewsModel[pos]
                                      .categoriesString![0]
                                      .replaceAll("&amp;", "&"),
                                  style: TextStyle(
                                    fontSize: 5 * fontSizeController.value,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                  // Constants.readTimestamp('${homeNewsModel[pos].date}'),
                                    Jiffy('${homeNewsModel[pos].date}').fromNow(),
                                  style: TextStyle(
                                      fontSize: 4 * fontSizeController.value,
                                      color: Theme.of(context).textTheme.bodyText1!.color)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  //FOR HOME FEATURED NEWS
  Widget imageSlider(List<HomeNewsModel> featuredNewsModel) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: InkWell(
          onTap: () {
            HomeNewsModel fNM = featuredNewsModel[0];
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<NewsTagBloc>(
                      create: (context) =>
                          NewsTagBloc(repository: Repository()),
                      child: NewsDetails(
                        newsModel: fNM,
                      )),
                ));
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Stack(
                fit: StackFit.expand,
                alignment: Alignment.topRight,
                children: <Widget>[
                  Image.network(
                    '${featuredNewsModel[0].xFeaturedMediaOriginal}',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        child: Html(
                          data: '${featuredNewsModel[0].title!.rendered}',
                          style: {
                            "body": Style(
                                fontSize: const FontSize(23.0),
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          },
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    CategoryListModel cLM = CategoryListModel ( );
                    cLM.id = "34";
                    cLM.categoryName = "Top Stories";
                    Navigator.push ( context , MaterialPageRoute(builder: (context)=>
                        BlocProvider<NewsByCategoryBloc> (
                            create: (context) =>
                                NewsByCategoryBloc (repository:Repository ( ) ) ,
                            child: NewsByCategory (
                              model: cLM , )
                        ) ,
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                            child: Icon(Icons.arrow_forward_rounded,
                                color: Colors.white))),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  //FOR FEATURED CACHED NEWS
  Widget imageSliderCached(List<HomeNewsModel> featuredNewsModel) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        child: InkWell(
          onTap: () {
            HomeNewsModel fNM = featuredNewsModel[0];
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<NewsTagBloc>(
                      create: (context) =>
                          NewsTagBloc(repository: Repository()),
                      child: NewsDetails(
                        newsModel: fNM,
                      )),
                ));
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Stack(
                fit: StackFit.expand,
                alignment: Alignment.topRight,
                children: <Widget>[
                  Image.network(
                    '${featuredNewsModel[0].xFeaturedMediaOriginal}',
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        child: Html(
                          data: '${featuredNewsModel[0].title!.rendered}',
                          style: {
                            "body": Style(
                                fontSize: const FontSize(23.0),
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          },
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    // CategoryListModel cLM = CategoryListModel(id:"34",categoryName:"Top Stories");
                    // Navigator.push( context, MaterialPageRoute(builder: (context)=>
                    //     BlocProvider<NewsByCategoryBloc>(
                    //         create: (context) => NewsByCategoryBloc(repository: Repository()),
                    //         child: NewsByCategory(model: cLM,)
                    //     ),
                    // ));

                    CategoryListModel cLM = CategoryListModel ( );
                    cLM.id = "34";
                    cLM.categoryName = "Top Stories";
                    Navigator.push ( context , MaterialPageRoute(builder: (context)=>
                        BlocProvider<NewsByCategoryBloc> (
                            create: (context) =>
                                NewsByCategoryBloc (repository:Repository ( ) ) ,
                            child: NewsByCategory (
                              model: cLM , )
                        ) ,
                    ));
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child:const  Center(
                            child: Icon(Icons.arrow_forward_rounded,
                                color: Colors.white))),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
