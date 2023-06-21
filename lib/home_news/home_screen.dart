import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:punch_ios_android/news_by_category/news_by_category_bloc.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_screen.dart';
import 'package:punch_ios_android/news_tag/news_tag_bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/screens/news_details.dart';
import 'package:punch_ios_android/search_result/search_result.dart';
import 'package:punch_ios_android/search_result/search_result_bloc.dart';
import 'package:punch_ios_android/utility/ad_helper.dart';
import 'package:punch_ios_android/utility/app_provider.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:punch_ios_android/widgets/build_error_ui.dart';
import 'package:punch_ios_android/widgets/build_loading_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:native_ads_flutter/native_ads.dart';

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
  late FeaturedNewsBloc featuredNewsBloc;
  late CategoryListModel categoryListModel;
  late RefreshController refreshController;
  late FontSizeController fontSizeController;
  // late StreamSubscription subscription;
  late AppProvider? appProvider;
  final String searchQuery = 'a';
  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  final ScrollController sc = ScrollController();
  final String _searchQuery= 'a';

  final double height = 0;

  double _height =0;
  late StreamSubscription _subscription;
  final _nativeAdController = NativeAdmobController();

  // for the refresh action
  bool isRefreshing = false;
  bool darkTheme = false;
  bool isSaved = false;

  // pagination
  List<HomeNewsModel> allHomeNews = [];
  int currentPage = 1;
  bool isLoadingMore = false;

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
    featuredNewsBloc.add(FetchFeaturedNewsEvent());
  }

  void _onStateChanged(AdLoadState state) {
  switch (state) {
  case AdLoadState.loading:
  setState(() {
  _height = 0;
  });
  break;

  case AdLoadState.loadCompleted:
  setState(() {
  _height = 150;
  });
  break;

  default:
  break;
  }
  }

  @override
  void initState() {
    super.initState();
    fontSizeController = Provider.of<FontSizeController>(context, listen: false);
    homeNewsBloc = BlocProvider.of<HomeNewsBloc>(context);
    homeNewsBloc.add(FetchHomeNewsEvent());

    categoryListBloc = BlocProvider.of<CategoryListBloc>(context);
    categoryListBloc.add(FetchCategoryListEvent());

    featuredNewsBloc = BlocProvider.of<FeaturedNewsBloc>(context);
    featuredNewsBloc.add(FetchFeaturedNewsEvent());

    appProvider = Provider.of<AppProvider>(context, listen: false);

    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
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
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          onRefresh: refresh,
          footer: CustomFooter(
            builder: (context, mode) {
              Widget body;
              if (isLoadingMore == false) {
                body = const Text("No more news");
                print("current status of is loading more :" +
                    isLoadingMore.toString());
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
                SizedBox(
                  height: 250,
                  child: BlocListener<FeaturedNewsBloc, FeaturedNewsState>(
                      listener: (context, state){
                        if ( state is FeaturedNewsRefreshingState ) {
                          // Scaffold.of ( context ).showSnackBar ( SnackBar (
                          //   content: Text ( 'Refreshing' ) , ) );
                        } else if ( state is FeaturedNewsLoadedState ) {

                        }else if ( state is FeaturedCachedNewsLoadedState  ) {
                          // a message will only come when it is updating the feed.
                        }
                        else if ( state is FeaturedNewsLoadFailureState ) {
                          // Scaffold.of ( context ).showSnackBar ( SnackBar (
                          //   content: Text ( "Could not load news at this time" ) , ) );
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
                          if (state is FeaturedNewsInitialState) {
                            return const BuildLoadingWidget();
                          } else if (state is FeaturedNewsLoadingState) {
                            return const BuildLoadingWidget();
                          } else if (state is FeaturedNewsLoadedState) {
                            return imageSlider(state.featuredNews);
                          } else if (state is FeaturedNewsRefreshedState) {
                            return imageSlider(state.featuredNews);
                          }else if (state is FeaturedCachedNewsLoadedState) {
                            return imageSliderCached(state.featuredCachedNews);
                          } else if (state is FeaturedNewsLoadFailureState) {
                            return BuildErrorUi(message: state.error);
                          } else {
                            return const BuildErrorUi(
                                message: "Something went wrong!");
                          }
                        },
                      )),
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
        ),
      );
    });
  }

  Widget getAd() {
    BannerAdListener bannerAdListener =
    BannerAdListener(onAdWillDismissScreen: (ad) {
      ad.dispose();
    }, onAdClosed: (ad) {
      debugPrint("Ad Got Closeed");
    });
    BannerAd bannerAd = BannerAd(
      size: AdSize.banner,
      // adUnitId: AdHelper.homeBanner2,
      adUnitId: Platform.isAndroid
          ? "ca-app-pub-3940256099942544/6300978111"
          : "ca-app-pub-3940256099942544/2934735716",
      listener: bannerAdListener,
      request: const AdRequest(),
    );

    bannerAd.load();

    return SizedBox(
      height: 120,
      child: AdWidget(ad: bannerAd),
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
                                        fontSize: FontSize(8*fontSizeController.value),
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
            //   _bannerReady?SizedBox(
            //   width: _bannerAd.size.width.toDouble(),
            //   height: _bannerAd.size.height.toDouble(),
            //   child: AdWidget(ad: _bannerAd),
            // ):Container();
             
            // return Container(
            //   width: myBanner!.size.width.toDouble(),
            //   height: 72.0,
            //   alignment: Alignment.center,
            //   child: AdWidget(ad: myBanner, key: UniqueKey(),),
            // );
            // return index % 5 == 0
            //     ? Container(
            //     margin: const EdgeInsets.symmetric(vertical: 10),
            //     child: index % 10 == 0
            //         ?
            //     SizedBox(child: adWidget, height: 100,)
            //
            //         :  SizedBox( child: secondWidget , height: 100, )
            // )
            //     : Container(height: 10);

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
                                    fontSize: FontSize(8*fontSizeController.value),
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

  //FOR FEATURED NEWS
  Widget imageSlider(List<HomeNewsModel> featuredNewsModel){
    return  ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                    bottom: 0.0, left: 0.0, right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.8),Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.5),Colors.black.withOpacity(0.0)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                        child: Html(
                          data: '${featuredNewsModel[0].title!.rendered}',
                          style: {
                            "body": Style(
                                fontSize: const FontSize(25.0),
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          },
                        ),
                    ),
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
                    bottom: 0.0, left: 0.0, right: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.8),Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.5),Colors.black.withOpacity(0.0)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                        child: Html(
                          data: '${featuredNewsModel[0].title!.rendered}',
                          style: {
                            "body": Style(
                                fontSize: const FontSize(25.0),
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          },
                        )

                    ),
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