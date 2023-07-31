import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:punch_ios_android/category_list/model.dart';
import 'package:punch_ios_android/deep_link/deep_link_details_event.dart';
import 'package:punch_ios_android/deep_link/deep_link_details_state.dart';
import 'package:punch_ios_android/deep_link/deeplink_details_bloc.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_bloc.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_screen.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/screens/font_test.dart';
import 'package:punch_ios_android/utility/ad_helper.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/utility/deeplink_news_details_provider.dart';
import 'package:punch_ios_android/utility/details_provider.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:punch_ios_android/widgets/build_error_ui.dart';
import 'package:punch_ios_android/widgets/build_loading_widget.dart';
import 'package:punch_ios_android/widgets/custom_alert_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// this is the deeplink that works for search

class DeepLinkNewsDetailsBloc extends StatefulWidget {
   final HomeNewsModel? newsModel;

 final String? slug;

   const DeepLinkNewsDetailsBloc ({Key? key ,  this.slug, this.newsModel}) : super( key: key );

  @override
  _DeepLinkNewsDetailsBlocState createState() => _DeepLinkNewsDetailsBlocState();
}

class _DeepLinkNewsDetailsBlocState extends State<DeepLinkNewsDetailsBloc> {

  bool isSaved=false;
  late DeepLinkDetailsBloc _deepDetailsProvider;
  late HomeNewsModel homeNewsModel;
  late FontSizeController _fontSizeController;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  bool adShown=true;


  final Completer<WebViewController> controller = Completer<WebViewController>();

  fontDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
          child: const  ChangeTextSizeWithSeekBar()
      ),
    );
  }

  final BannerAd articleMedium = BannerAd(
    adUnitId: AdHelper.articleMedium,
    size: AdSize.mediumRectangle,
    request: const AdRequest(),
    listener:  const BannerAdListener(),
  );

  final BannerAd inArticleAds = BannerAd(
    adUnitId: AdHelper.homeBanner,
    size: AdSize.largeBanner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  final AdManagerBannerAd adManagerBannerAd = AdManagerBannerAd(
    adUnitId: AdHelper.adManagerBannerUnitId,
    // sizes: [AdSize.largeBanner],
    sizes: [AdSize(width: 300, height: 250)],
    request: AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  );

  final AdSize adSize =  const AdSize(width: 300, height: 250);

  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-7167863529667065/3759929490'
            : 'ca-app-pub-7167863529667065/7063763571',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            // print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      // print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print(''),
          // print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        // print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        // print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  Widget getAd() {
    BannerAdListener bannerAdListener =
    BannerAdListener(onAdWillDismissScreen: (ad) {
      ad.dispose();
    }, onAdClosed: (ad) {
      // debugPrint("Ad Got Closeed");
    });
    BannerAd bannerAd = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: Platform.isAndroid
      //working ad medium size
          ? "ca-app-pub-7167863529667065/7963339325"
          : "ca-app-pub-7167863529667065/1645777752",

      // ? "ca-app-pub-3940256099942544/6300978111"
      // : "ca-app-pub-3940256099942544/2934735716",
      listener: bannerAdListener,
      request: const AdRequest(),
    );

    bannerAd.load();

    return SizedBox(
      height: 120,
      child: AdWidget(ad: bannerAd),
    );
  }


  @override
  void initState() {
    super.initState();
    _fontSizeController = Provider.of<FontSizeController>(context, listen: false);

    DeepLinkNewsDetailsProvider _favoritesProvider = Provider.of<DeepLinkNewsDetailsProvider>(context, listen: false);
    _favoritesProvider.setSlug(widget.slug!);

    _deepDetailsProvider =BlocProvider.of<DeepLinkDetailsBloc>(context);
   _deepDetailsProvider.add(FetchDeepLinkDetailsEvent(slug:widget.slug!));

    articleMedium.load();
    inArticleAds.load();
    adManagerBannerAd.load();

    _createInterstitialAd();


  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }


  @override
  Widget build (BuildContext context) {
    final AdWidget mediumWidget = AdWidget(ad: articleMedium);
    final AdWidget inArticleWidget = AdWidget(ad: inArticleAds);
    final AdWidget adManagerBannerWidget = AdWidget(ad: adManagerBannerAd);


    return Consumer<FontSizeController>(
      builder: (context, fontScale, child) {
        return Consumer<DeepLinkNewsDetailsProvider>(
            builder: ( context,  deepProvider,  child) {
          HomeNewsModel? newsModel = deepProvider.getNewsDetails();
          return Consumer<DetailsProvider>(
              builder: ( context,  detailsProvider,  child) {

        return Scaffold (
          appBar: AppBar (
            leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                  // _showInterstitialAd();
                },
                icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyText1!.color,)
            ),

            actions: <Widget>[

              IconButton (
                onPressed: () {
                  fontDialog ( );
                } ,
                icon: Icon (
                    Icons.text_fields ,
                    color: Theme.of(context).textTheme.bodyText1!.color
                ) ,
              ) ,

              IconButton (
                onPressed: () async {
                  if ( isSaved==true ) {

                    detailsProvider.removeFav ( newsModel.id!);
                    setState(() {
                      isSaved = false;
                    });

                  } else {
                    detailsProvider.addFav (newsModel );
                    setState(() {
                      isSaved = true;
                    });
                  }
                } ,
                icon: Visibility(
                  visible: deepProvider.isLoadSuccessful==true,
                  child: Icon (
                    isSaved==true
                        ? Icons.favorite: Icons.favorite_border ,
                    color:  isSaved==true
                        ? Colors.red
                        : Theme.of ( context ).iconTheme.color ,
                  ),
                ) ,
              ) ,

              // InkWell(
              //   child: Icon (
              //       Icons.share ,
              //       color: Theme.of(context).textTheme.bodyText1!.color
              //   ) ,
              //   onTap: () {
              //     //
              //     // FlutterShare.share(
              //     //   title: 'Punch News' ,
              //     //   // text: '${widget.newsModel!.title!.rendered}',
              //     //
              //     //   text: 'Download Punch News App' ,
              //     //   linkUrl: 'https://apps.apple.com/ng/app/punch-news/id1416286632',
              //     //   // chooserTitle: 'Something for chooser title',
              //     // );
              //
              //     FlutterShare.share(
              //       title: 'Punch News' ,
              //     text: '${newsModel.title!.rendered}'
              //           .replaceAll (r"\n" , "\n" ).replaceAll ( r"\r" , "" )
              //           .replaceAll ( r"\'" , "'" ).replaceAll ( "<p>" , "" )
              //           .replaceAll ("&#8217;" , "'" ).replaceAll ("&#038;" , "&" )
              //           .replaceAll ("&#8216;" , "‘" ).replaceAll("&#8211;", "-"),
              //       linkUrl:'https://punchng.com/' '${widget.newsModel!.slug} ',
              //       // chooserTitle: 'Something for chooser title',
              //     );
              //   },
              // ),

                  SizedBox(width: 20,),
            ] ,
          ) ,


          body:  BlocListener<DeepLinkDetailsBloc, DeepLinkDetailsState>(
                listener: (context, state) {
                if ( state is DeepLinkDetailsLoadedState ) {
                  deepProvider.setLoadSuccess(true);
                  deepProvider.setNewsDetails(state.model);
                 //  detailsProvider.checkFav(state.model.id!).then((value) {
                 //    setState(() {
                 //      isSaved = value;
                 //    });
                 //  });
                 }
                },

              child: BlocBuilder<DeepLinkDetailsBloc, DeepLinkDetailsState>(
                builder: (context, state) {
                  if ( state is DeepLinkDetailsInitialState ) {
                    return const BuildLoadingWidget ( );
                  } else if ( state is DeepLinkDetailsLoadingState ) {
                    return const BuildLoadingWidget ( );
                  } else if ( state is DeepLinkDetailsLoadedState ) {
                    return   ListView (
                      padding:  const EdgeInsets.symmetric ( horizontal: 10 ) ,
                      children: <Widget>[
                        Stack (
                          alignment: Alignment.center ,
                          children: <Widget>[
                            ClipRRect (
                              borderRadius: const BorderRadius.all (
                                Radius.circular ( 10.0 ) , ) ,
                              child: CachedNetworkImage (
                                imageUrl: '${state.model.xFeaturedMediaLarge}' ,
                                placeholder: (context , url) =>
                                const Center (
                                  child: CircularProgressIndicator (color: mainColor) , ) ,
                                errorWidget: (context , url , error) =>
                                Image.asset ( 'assets/punchLogo.png' ) ,
                                // Ico n ( Icons.close ) ,
                                fit: BoxFit.contain ,
                              ) ,
                            ),
                          ] ,
                        ) ,

                       const  SizedBox ( height: 5 ),

                        Column (
                          mainAxisSize: MainAxisSize.max ,
                          crossAxisAlignment: CrossAxisAlignment.end ,
                          children: <Widget>[
                            const SizedBox ( height: 15 , ) ,
                            Align(
                              alignment: Alignment.topRight,
                              child: Container (
                                padding: const EdgeInsets.symmetric( vertical: 5 ) ,
                                child: Column(
                                  children: [

                                    Material (
                                        type: MaterialType.transparency ,
                                        child: Html(
                                          data:  '${state.model.title!.rendered}',
                                          style: {
                                            "body": Style(
                                                fontSize:  FontSize(10*_fontSizeController.value),
                                                fontWeight: FontWeight.w500,
                                                color:Theme.of(context).textTheme.bodyText1!.color
                                            ),
                                          },
                                        )
                                    ) ,
                                    const SizedBox  ( height: 10 , ) ,

                                    Row (
                                      children: <Widget>[
                                        Container (
                                          padding: const EdgeInsets.only ( left: 0 ) ,
                                          child: Icon ( Icons.person ,
                                            color: Theme.of ( context ).primaryColor ,
                                            size: 12.0 ,
                                          ) ,
                                        ) ,
                                        Expanded (
                                          child: Container (
                                              padding: const EdgeInsets.only ( left: 5 ) ,
                                              child: Text (
                                                '${state.model.xAuthor}',
                                                style: TextStyle (color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 12 ) ,
                                                overflow: TextOverflow.ellipsis ,
                                                maxLines: 2 ,
                                              )
                                          ) ,
                                        ) ,
                                      ] ,
                                    ),
                                  ],
                                ) ,
                              ),
                            ) ,

                            const SizedBox  ( height: 10 , ) ,

                            Row (
                              children: [
                                SizedBox (
                                  height: 25 ,
                                  child: ListView.builder (
                                    scrollDirection: Axis.horizontal ,
                                    itemCount: 1 ,
                                    shrinkWrap: true ,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container (
                                          padding: const EdgeInsets.symmetric ( horizontal: 5 , vertical: 3 ) ,
                                          margin: const EdgeInsets.only ( right: 5.0 ) ,
                                          decoration: BoxDecoration ( borderRadius: BorderRadius.circular ( 5 ) ,
                                            color: mainColor ,
                                          ) ,
                                          child: Center (
                                            child: GestureDetector (
                                              onTap: () {
                                                CategoryListModel cLM = CategoryListModel ( );
                                                cLM.categoryId = state.model.categories![0].toString ( );
                                                cLM.categoryName = state.model.categoriesString![0];
                                                Navigator.push ( context , MaterialPageRoute(builder: (context)=>BlocProvider<NewsByCategoryBloc> (
                                                    create: (context) => NewsByCategoryBloc (repository: Repository ()) ,
                                                    child: NewsByCategory ( model: cLM , )
                                                    ) ,
                                                  )
                                                );
                                              } ,
                                              child:  Text (
                                                state.model.categoriesString![0].replaceAll("&amp;", "&"),
                                                style: const TextStyle (fontSize: 10 , color: Colors.white,
                                                ) ,
                                              ) ,
                                            ) ,
                                          ) ,
                                        );
                                    } ,
                                  ) ,
                                ) ,
                                const Spacer ( ) ,

                                Container (
                                  padding:  const EdgeInsets.only ( left: 5 ) ,
                                  child: Text (
                                      Jiffy('${state.model.date}').fromNow(),
                                      maxLines: 2 ,
                                      style: TextStyle (fontSize: 12, color: Theme.of(context).textTheme.bodyText1!.color,
                                      ) ) ,
                                ) ,
                              ] ,
                            ) ,
                          ] ,
                        ),

                        Divider ( color: Theme.of ( context ).textTheme.caption!.color ) ,

                        const SizedBox ( height: 15 ) ,

                        //FOR AD MANAGER UNITS
                        adShown?  Center(
                            child: SizedBox(
                              width: 300,
                              height: 250,
                              child: adManagerBannerWidget,
                            ))
                            : Container(height: 0),

                        //NEWS DETAILS BODY
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: state.model.articleSplit!.length,
                            itemBuilder: (BuildContext context , int index) {
                              if (index != 0 && index % 5 == 0) {
                                return getAd();
                              } else {
                                return Html (
                                  data: state.model.articleSplit![index].toString(),
                                  style: {
                                    "body": Style(
                                        fontSize:  FontSize(10*_fontSizeController.value),
                                        fontWeight: FontWeight.w400,
                                        color:Theme.of(context).textTheme.bodyText1!.color
                                    ),
                                  },
                                );
                              }
                            },

                            // itemBuilder: (BuildContext context , int index) {
                            //   if (index != 0 && index % 5 == 0) {
                            //     return getAd();
                            //   } else   {
                            //      Html (
                            //       data: state.model.articleSplit![index].toString(),
                            //       style: {
                            //         "body": Style(
                            //             fontSize:  FontSize(9*_fontSizeController.value),
                            //             fontWeight: FontWeight.w400,
                            //             color:Theme.of(context).textTheme.bodyText1!.color
                            //         ),
                            //       },
                            //     );
                            //   }
                            // },
                            separatorBuilder: ( context, index) {
                              return Container();

                              // return index != 0 && index % 5 == 0
                              //     ? SizedBox(
                              //   child: inArticleWidget,
                              //   height: 100,
                              // )
                              //     : Container(height: 10);
                            }
                        ),

                        const SizedBox ( height: 15 ) ,

                        //  SizedBox (
                        //   child: mediumWidget ,
                        //   width: MediaQuery.of ( context ).size.width ,
                        //   height: 250,
                        // ) ,

                        //FOR AD MANAGER UNITS
                        adShown?  Center(
                            child: SizedBox(
                              width: 300,
                              height: 250,
                              child: adManagerBannerWidget,
                            ))
                            : Container(height: 0),


                        const SizedBox(height: 15),

                      ] ,
                    );
                  }
                  else if ( state is DeepLinkDetailsLoadFailureState ) {
                    return BuildErrorUi(message: state.error );
                  }
                  else {
                    return const BuildErrorUi (message: "Something went wrong!" );
                  }
                },
              ),
            ),
          );
           });
          },
        );
      }
    );
  }
}



