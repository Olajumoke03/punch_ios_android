import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_funding_choices/flutter_funding_choices.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:jiffy/jiffy.dart';
import 'package:punch_ios_android/category_list/bloc.dart';
import 'package:punch_ios_android/category_list/event.dart';
import 'package:punch_ios_android/category_list/model.dart';
import 'package:punch_ios_android/featured_news/featured_news_bloc.dart';
import 'package:punch_ios_android/featured_news/featured_news_event.dart';
import 'package:punch_ios_android/featured_news/featured_news_state.dart';
import 'package:punch_ios_android/home_news/home_bloc.dart';
import 'package:punch_ios_android/home_news/home_event.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/home_news/home_state.dart';
import 'package:punch_ios_android/live_video/live_video_bloc.dart';
import 'package:punch_ios_android/live_video/live_video_event.dart';
import 'package:punch_ios_android/live_video/live_video_model.dart';
import 'package:punch_ios_android/live_video/live_video_response.dart';
import 'package:punch_ios_android/live_video/live_video_state.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_bloc.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_screen.dart';
import 'package:punch_ios_android/news_tag/news_tag_bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/screens/news_details.dart';
import 'package:punch_ios_android/search_result/search_result.dart';
import 'package:punch_ios_android/search_result/search_result_bloc.dart';
import 'package:punch_ios_android/utility/app_provider.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:punch_ios_android/widgets/build_error_ui.dart';
import 'package:punch_ios_android/widgets/build_loading_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:native_ads_flutter/native_ads.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart' as webView;
import 'package:flutter_funding_choices/flutter_funding_choices.dart' as consent;

class HomeNewsScreen extends StatefulWidget {
  const HomeNewsScreen({Key? key}) : super(key: key);

  @override
  _HomeNewsScreenState createState() => _HomeNewsScreenState();
}

class _HomeNewsScreenState extends State<HomeNewsScreen> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  late HomeNewsBloc homeNewsBloc;
  late Repository repository;
 late  FeaturedNewsBloc featuredNewsBloc;

  late HomeNewsModel homeModel;
  late CategoryListBloc categoryListBloc;
  late LiveVideoBloc liveVideoBloc;
  late CategoryListModel categoryListModel;
  late RefreshController refreshController;
  late FontSizeController fontSizeController;
  late AppProvider? appProvider;
  final String searchQuery = 'a';
  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  final ScrollController sc = ScrollController();
  final String _searchQuery= 'a';
  final  httpClient = http.Client();
  late StreamSubscription subscription;
  final _nativeAdController = NativeAdmobController();

  bool isLoading=true;
  double height = 0;

  // for the refresh action
  bool isRefreshing = false;
  bool darkTheme = false;
  bool isSaved = false;

  // pagination
  List<HomeNewsModel> allHomeNews = [];
  int currentPage = 1;
  bool isLoadingMore = false;

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final _key = UniqueKey();

  void loadMore() {
    // make sure that it is not already loading
    if (isLoadingMore == false) {
      // show the loading indicator
      setState(() {
        isLoadingMore = true;
      });

      homeNewsBloc.add(FetchMoreHomeNewsEvent(page: currentPage + 1));
      featuredNewsBloc.add ( FetchFeaturedNewsEvent () );

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
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          height = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          height = 150;
        });
        break;

      default:
        break;
    }
  }
  /// The current consent info.
  late consent.ConsentInformation consentInfo;

  /// Refreshes the current consent info.
  Future<void> refreshConsentInfo() async {
    List<String> testDeviceId = [];
    testDeviceId.add("EF47A78D1DFDE273A8AC31A5EE4F6FAF");
    consent.ConsentInformation consentInfo =
    await FlutterFundingChoices.requestConsentInformation(tagForUnderAgeOfConsent: false,testDevicesHashedIds: testDeviceId );
    setState(() => this.consentInfo = consentInfo);

  }
  /// Converts a consent status to a human-readable string.
  String get consentStatusString {
    if (consentInfo.consentStatus == consent.ConsentStatus.OBTAINED) {
      return 'Obtained';
    }
    if (Platform.isAndroid) {
      if (consentInfo.consentStatus == 1) {
        return 'Not required';
      }
      if (consentInfo.consentStatus == 2) {
        return 'Required';
      }
    } else if (Platform.isIOS) {
      if (consentInfo.consentStatus == 1) {
        return 'Not required';
      }
      if (consentInfo.consentStatus == 2) {
        return 'Required';
      }
    }
    return 'Unknown';
  }

  /// Converts a consent type to a human-readable string.
  // String get consentTypeString {
  //   switch (consentInfo.consentType) {
  //     case ConsentType.PERSONALIZED:
  //       return 'Personalized ads';
  //     case ConsentType.NON_PERSONALIZED:
  //       return 'Non personalized ads';
  //     default:
  //       return 'Unknown';
  //   }
  // }

  List<LiveVideoModel> liveVideoModel = <LiveVideoModel>[];
  //API CALL FOR LIVE VIDEO
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

    featuredNewsBloc = BlocProvider.of<FeaturedNewsBloc> ( context );
    featuredNewsBloc.add ( FetchFeaturedNewsEvent () );

    categoryListBloc = BlocProvider.of<CategoryListBloc>(context);
    categoryListBloc.add(FetchCategoryListEvent());


    liveVideoBloc = BlocProvider.of<LiveVideoBloc> ( context );
    liveVideoBloc.add ( FetchLiveVideosEvent () );

    appProvider = Provider.of<AppProvider>(context, listen: false);

    subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    fetchLiveVideo();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await refreshConsentInfo();
      if (consentInfo.isConsentFormAvailable && consentInfo.consentStatus == 2) {
        await FlutterFundingChoices.showConsentForm();
        await refreshConsentInfo();
      }

    });
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
          actions: [
            IconButton (
              onPressed: () {
                Navigator.push( context, MaterialPageRoute(builder: (context)=>
                    BlocProvider<SearchResultBloc>(
                        create: (context) => SearchResultBloc(repository: Repository()),
                        child: SearchResult(searchQuery: _searchQuery)
                    ) )
                );
              } ,
              icon: Center(
                child: Icon (
                    Icons.search , size: 30,
                    color: Theme.of(context).textTheme.bodyText1!.color
                ),
              ) ,
            ) ,
            SizedBox(width: 10,)
          ],
        ),
        body:

          liveVideoModel.isNotEmpty && liveVideoModel[0].streaming == true
          // liveVideoTest.isNotEmpty

      ?liveVideoHomeScreen()

          :mainHomeScreen()

      );
    });
  }

  Widget getAd() {
    BannerAdListener bannerAdListener =
    BannerAdListener(onAdWillDismissScreen: (ad) {
      ad.dispose();
    }, onAdClosed: (ad) {
      // debugPrint("Ad Got Closed");
    });
    BannerAd bannerAd = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: Platform.isAndroid


      //working ad medium size
      ? "ca-app-pub-7167863529667065/7963339325"
      : "ca-app-pub-7167863529667065/1645777752",

      listener: bannerAdListener,
      request: const AdRequest(),
    );

    bannerAd.load();

    return SizedBox(
      height: 120,
      child: AdWidget(ad: bannerAd),
    );
  }

  //Main Home Screen(without live video)
  Widget mainHomeScreen(){
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: refresh,
      footer: CustomFooter(
        builder: (context, mode) {
          Widget body;
          if (isLoadingMore == false) {
            body = const Text("No more news");
            // print("current status of is loading more :" + isLoadingMore.toString());
          } else {
            body = const SizedBox(
                child: CircularProgressIndicator(
                  color: mainColor,
                ),
                height: 30,
                width: 30);
          }

          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      header: const ClassicHeader(),
      onLoading: loadMore,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              child:
              BlocListener <FeaturedNewsBloc, FeaturedNewsState>(
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
                      // returning false here when we have a load failure state means that.
                      // we do not want the widget to rebuild when there is error
                      if(current is FeaturedNewsLoadFailureState)
                        return false;
                      else
                        return true;
                    },
                    builder: (context, state) {
                      if ( state is FeaturedNewsInitialState ) {
                        return SizedBox(
                            height: 125,
                            width: 248,
                            child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor))                        );
                      } else if ( state is FeaturedNewsLoadingState ) {
                        return  SizedBox(
                            height: 125,
                            width: 248,
                            child: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor))
                        );

                      } else if ( state is FeaturedNewsLoadedState ) {
                        return Container(
                            child: imageSlider( state.featuredNews));
                        // return buildFeaturedNewsList ( state.featuredNews);
                      }else if ( state is FeaturedCachedNewsLoadedState ) {
                        return Container(
                            child: imageSliderCached( state.featuredCachedNews));
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
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 10.0, 0.0, 10.0),
                    child: Container(
                      margin:const EdgeInsets.symmetric(horizontal: 5),
                      // color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Text("LATEST NEWS",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ),
                  ),
                  BlocListener<HomeNewsBloc, HomeNewsState>(
                    listener: (context, state) {
                      if (state is HomeNewsRefreshingState) {
                        setRefreshing(true);
                      }
                      else if (state is HomeNewsRefreshedState) {
                        setState(() {
                          currentPage = 1;
                          isRefreshing = false;
                          _refreshController.refreshCompleted();
                          allHomeNews.clear();
                          allHomeNews = state.homeNews;
                        });
                      } else if (state is HomeNewsLoadedState) {
                        setState(() {
                          currentPage = 1;
                          isRefreshing = false;
                          _refreshController.refreshCompleted();
                          allHomeNews = state.homeNews;
                        });
                      } else if (state is HomeNewsMoreLoadedState) {
                        setState(() {
                          currentPage++;
                          isLoadingMore = false;
                          _refreshController.loadComplete();
                          allHomeNews.addAll(state.homeNews);
                        });
                      } else if (state is HomeNewsMoreFailureState) {
                        setState(() {
                          isLoadingMore = false;
                        });
                      } else if (state is HomeNewsLoadFailureState) {
                        setRefreshing(false);
                      } else {
                        setRefreshing(false);
                      }
                    },
                    child: BlocBuilder<HomeNewsBloc, HomeNewsState>(
                      buildWhen: (previous, current) {
                        // returning false here when we have a load failure state means that.
                        // we do not want the widget to rebuild when there is error
                        if (current is HomeNewsLoadFailureState ||
                            current is HomeNewsRefreshingState ||
                            current is HomeNewsMoreLoadedState ||
                            current is HomeNewsMoreFailureState ||
                            current is HomeNewsLoadingMoreState) {
                          return false;
                        } else {
                          return true;
                        }
                      },
                      builder: (context, state) {
                        if (state is InitialState) {
                          return const BuildLoadingWidget();
                        } else if (state is HomeNewsLoadingState) {
                          return const BuildLoadingWidget();
                        } else if (state is HomeNewsLoadedState) {
                          return buildHomeNewsList(allHomeNews);
                        } else if (state is HomeNewsRefreshedState) {
                          return buildHomeNewsList(allHomeNews);
                        } else if (state is HomeCachedNewsLoadedState) {
                          return buildHomeCachedNews(state.cachedNews);
                        } else if (state is HomeNewsLoadFailureState) {
                          return BuildErrorUi(message: state.error);
                        } else {
                          return const BuildErrorUi(
                              message: "Something went wrong!");
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
                  // returning false here when we have a load failure state means that.
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
                          //   content: Text ( "Could not load latest news at this time" ) , ) );
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
                    // initialUrl: "https://www.facebook.com/plugins/video.php?height=314&href=https%3A%2F%2Fwww.facebook.com%2Fpunchnewspaper%2Fvideos%2F583140406599951%2F&show_text=false&width=560&t=0",
                    javascriptMode: JavascriptMode.unrestricted ,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete ( webViewController );
                    } ,
                    navigationDelegate: (webView.NavigationRequest request) {
//                         if (request.url.startsWith('https://www.youtube.com/')) {
//                           return NavigationDecision.prevent;
//                         }
                      return webView.NavigationDecision.navigate;
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
              child: Material(
                  type: MaterialType.transparency,
                  child: Html(
                    data: '${liveVideoModel[0].data!.title}',
                    style: {
                      "body": Style(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: FontSize(9*fontSizeController.value),
                          fontWeight:FontWeight.w500
                      ),
                    },
                  )),
            ),

            Divider(color: Theme.of(context).textTheme.bodyText1!.color,),
          ],
        )
    );

  }

//HOME NEWS
  Widget buildHomeNewsList(List<HomeNewsModel> homeNewsModel) {
    return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 7,),
          scrollDirection: Axis.vertical,
          itemCount: homeNewsModel.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, pos) {
            if (pos % 6 == 0) {
              return getAd();
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
                                        color: Theme.of(context).textTheme.bodyText1!.color,
                                        fontSize: FontSize(9*fontSizeController.value),
                                        fontWeight:FontWeight.w500
                                    ),
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
                                                    create: (context) => NewsByCategoryBloc(repository: Repository()),
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
          separatorBuilder: (context, index) {
            return Container();
              }
          );
  }

  //FOR HOME CACHED NEWS
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
                                    color: Theme.of(context).textTheme.bodyText1!.color,
                                    fontSize: FontSize(9*fontSizeController.value),
                                    fontWeight:FontWeight.w500
                                ),
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
                                  Jiffy('${homeNewsModel[pos].date}').fromNow(),
                                  style: TextStyle(
                                      fontSize: 4.5 * fontSizeController.value,
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

  //FOR FEATURED NEWS
  Widget imageSlider(List<HomeNewsModel> featuredNewsModel){
    return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: InkWell(
            onTap: (){
              HomeNewsModel fNM = featuredNewsModel[0];
              Navigator.push ( context ,
                  MaterialPageRoute(
                    builder: (context) =>  BlocProvider<NewsTagBloc> (
                        create: (context) => NewsTagBloc (repository: Repository ()) ,
                        child: NewsDetails ( newsModel: fNM , )
                    ) ,
                  )
              );
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
                      bottom: 0.0, left: 0.0, right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.8),Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.5),Colors.black.withOpacity(0.0)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                        child: Html(
                          data: '${featuredNewsModel[0].title!.rendered} ',
                          style: {
                            "body": Style(
                                color: Colors.white,
                                fontSize: FontSize(25),
                                fontWeight:FontWeight.bold
                            ),
                          },
                          // defaultTextStyle: TextStyle(color: Colors.white, fontSize: 23,fontWeight:FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      CategoryListModel cLM = CategoryListModel(categoryId:"34",categoryName:"Top Stories");
                      Navigator.push( context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider<NewsByCategoryBloc>(
                                create: (context) => NewsByCategoryBloc(repository: Repository()),
                                child: NewsByCategory(model: cLM,)
                            ),
                          )
                      );
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
                          child: Center(child: Icon(Icons.arrow_forward_rounded, color: Colors.white))),
                    ),
                  ),
                ),
              ],
            ),
          )
    );
  }

  // FOR FEATURED CACHED NEWS
  Widget imageSliderCached(List<HomeNewsModel> featuredNewsModel){
    return  ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        child: InkWell(
          onTap: (){
            HomeNewsModel fNM = featuredNewsModel[0];
            Navigator.push ( context ,
                MaterialPageRoute(
                  builder: (context) =>   BlocProvider<NewsTagBloc> (
                      create: (context) => NewsTagBloc (repository: Repository ()) ,
                      child: NewsDetails ( newsModel: fNM , )
                  ) ,
                )
            );
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
                    bottom: 0.0, left: 0.0, right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.8),Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.5),Colors.black.withOpacity(0.0)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Html(
                        data: '${featuredNewsModel[0].title!.rendered} ',
                        style: {
                          "body": Style(
                              color: Colors.white,
                              fontSize: FontSize(25),
                              fontWeight:FontWeight.bold
                          ),
                        },
                        // defaultTextStyle: TextStyle(color: Colors.white, fontSize: 23,fontWeight:FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    CategoryListModel cLM = CategoryListModel(categoryId:"13",categoryName:"Featured News");
                    Navigator.push( context,
                        MaterialPageRoute(
                          builder: (context) =>  BlocProvider<NewsByCategoryBloc>(
                              create: (context) => NewsByCategoryBloc(repository: Repository()),
                              child: NewsByCategory(model: cLM,)
                          ),

                        )

                    );
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
                        child: Center(child: Icon(Icons.arrow_forward_rounded, color: Colors.white))),
                  ),
                ),
              ),
            ],
          ),
        )
    );

  }
}