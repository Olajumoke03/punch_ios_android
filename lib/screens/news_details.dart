import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:punch_ios_android/news_tag/news_tag_bloc.dart';
import 'package:punch_ios_android/news_tag/news_tag_event.dart';
import 'package:punch_ios_android/news_tag/news_tag_state.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/search_result/search_model.dart';
import 'package:punch_ios_android/widgets/build_error_ui.dart';
import 'package:punch_ios_android/widgets/build_loading_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jiffy/jiffy.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/screens/font_test.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/utility/details_provider.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:punch_ios_android/widgets/custom_alert_dialog.dart';
import 'package:provider/provider.dart';


class NewsDetails extends StatefulWidget {
  late HomeNewsModel? newsModel;
  late SearchResultModel? searchResultModel;
  final String? newsId;

  NewsDetails ({Key? key , this.newsModel,  this.newsId,  this.searchResultModel,}) : super( key: key );

  @override
  _NewsDetailsState createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  late FontSizeController _fontSizeController;
  late NewsTagBloc newsTagBloc;

  int maxFailedLoadAttempts = 3;
  double _height =0;
  double _mediumHeight= 0;
  bool isSaved=false;
  bool videoloader = false;
  int currentPage = 1;
  bool _adShown=true;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  final AdManagerBannerAdListener listener = AdManagerBannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  final AdManagerBannerAd adManagerBannerAd = AdManagerBannerAd(
    adUnitId: '/6499/example/banner',
    // sizes: [AdSize.largeBanner],
    sizes: [AdSize(width: 300, height: 250)],
    request: AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  );

  final BannerAd articleMedium = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.mediumRectangle,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  final BannerAd inArticleAds = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.largeBanner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  final AdSize adSize = AdSize(width: 300, height: 250);

  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
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
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  fontDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
          child:   ChangeTextSizeWithSeekBar()
      ),
    );
  }

  @override
  void initState() {
    _fontSizeController = Provider.of<FontSizeController>(context, listen: false);
    newsTagBloc = BlocProvider.of<NewsTagBloc>(context);
    newsTagBloc.add(FetchNewsTagEvent(id: widget.newsModel!.tags!.join(",").toString()));

    DetailsProvider _detailsProvider = Provider.of<DetailsProvider>(context, listen: false);
    _detailsProvider.checkFav(widget.newsModel!.id!).then((value) {
      setState(() {
        isSaved = value;
      });
    });

    articleMedium.load();
    inArticleAds.load();

    _createInterstitialAd();

    adManagerBannerAd.load();

    super.initState();
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
        builder: ( context,  fontScale,  child) {
          return Consumer<DetailsProvider> (
              builder: ( context ,  detailsProvider,  child) {
                return Scaffold (
                    appBar: AppBar (
                      centerTitle: true,
                      title: Text("Punch News", style: TextStyle(color: Theme.of(context).textTheme.headline1!.color, fontSize: 20, fontWeight: FontWeight.w700 ),  ),
                      leading: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                            _showInterstitialAd();
                          },

                       icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.headline1!.color,)
                      ),
                      actions: <Widget>[
                        IconButton (
                          onPressed: () {
                            fontDialog ( );
                          } ,
                          icon: Icon (
                            Icons.text_fields ,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ) ,
                        ) ,

                        IconButton (
                          onPressed: () {
                            FlutterShare.share(
                                title: 'Punch News' ,
                                text: 'Read: ' '${widget.newsModel!.title!.rendered}' ', on Punch News'
                                    .replaceAll (r"\n" , "\n" ).replaceAll ( r"\r" , "" )
                                    .replaceAll ( r"\'" , "'" ).replaceAll ( "<p>" , "" )
                                    .replaceAll ("&#8217;" , "'" ).replaceAll ("&#038;" , "&" )
                                    .replaceAll ("&#8216;" , "‘" ).replaceAll("&#8211;", "-"),
                                linkUrl:'https://punchng.com/' '${widget.newsModel!.slug} ',
                                chooserTitle: 'Something for chooser title',

                            );
                            print("share text "  '${widget.newsModel!.title!.rendered}');
                            print("link url " 'https://punchng.com/' '${widget.newsModel!.slug}');

                          } ,
                          icon:  Icon (
                            Icons.share ,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ) ,
                        ) ,
                      ] ,
                    ) ,

                    body: Padding (
                      padding: const EdgeInsets.all( 15.0 ) ,
                      child: ListView (
                        children: <Widget>[
                          Stack (
                            alignment: Alignment.center ,
                            children: <Widget>[
                              ClipRRect (
                                borderRadius: const BorderRadius.all (
                                  Radius.circular ( 10.0 ) , ) ,
                                child: CachedNetworkImage (
                                  imageUrl: '${widget.newsModel!.jetpackFeaturedMediaUrl}' ,
                                  placeholder: (context , url) =>
                                     const Center (
                                      child: CircularProgressIndicator ( ) , ) ,
                                  errorWidget: (context , url , error) =>
                                      // Image.asset ( 'assets/punchLogo.png' ) ,
                                 const Text(" Punch News  "),
                                  // Ico n ( Icons.close ) ,
                                  fit: BoxFit.contain ,
                                ) ,
                              ),
                            ] ,
                          ) ,

                         const SizedBox ( height: 5 ) ,

                          Column (
                            mainAxisSize: MainAxisSize.max ,
                            crossAxisAlignment: CrossAxisAlignment.end ,
                            children: <Widget>[
                             const SizedBox ( height: 9 , ) ,
                              Material (
                                  type: MaterialType.transparency ,
                                  child: Html(
                                    data:  '${widget.newsModel!.title!.rendered}',
                                    style: {
                                      "body": Style(
                                          fontSize:  FontSize(9*_fontSizeController.value),
                                          fontWeight: FontWeight.w400,
                                          color:Theme.of(context).textTheme.bodyText1!.color
                                      ),
                                    },
                                  )
                              ) ,
                              const SizedBox ( height: 9 , ) ,
                              Row (
                                children: [
                                  SizedBox (
                                    height: 25 ,
                                    child: ListView.builder (
                                      scrollDirection: Axis.horizontal ,
                                      itemCount: 1 ,
                                      shrinkWrap: true ,
                                      itemBuilder: (BuildContext context ,
                                          int index) {
                                        // String cat = widget.newsModel.categoriesString[index].toString ( );
                                        return
                                          Container (
                                            padding: const EdgeInsets.symmetric ( horizontal: 5 , vertical: 3 ) ,
                                            margin: const EdgeInsets.only ( right: 5.0 ) ,
                                            decoration: BoxDecoration ( borderRadius: BorderRadius.circular ( 5 ) ,
                                              color: mainColor ,
                                            ) ,
                                            child: Center (
                                              child: GestureDetector (
                                                onTap: () {
                                                } ,
                                                child:  Text (
                                                  "${widget.newsModel!.xCategories}",
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
                                    padding: const EdgeInsets.only ( left: 5 ) ,
                                    child: Text (
                                        Jiffy('${widget.newsModel!.date}').fromNow(),
                                        maxLines: 2 ,
                                        style: TextStyle (fontSize: 12, color: Theme.of(context).textTheme.bodyText1!.color,
                                        ) ) ,
                                  ) ,

                                ] ,
                              ) ,
                              const SizedBox  ( height: 9 , ) ,

                              Padding (
                                padding: const EdgeInsets.symmetric( vertical: 5 ) ,
                                child: Column(
                                  children: [
                                    Row (
                                      children: <Widget>[
                                        Container (
                                          padding: const EdgeInsets.only ( left: 0 ) ,
                                          child: Icon ( Icons.person ,
                                            color: Theme.of ( context ).accentColor ,
                                            size: 12.0 ,
                                          ) ,
                                        ) ,
                                        Expanded (
                                          child: Container (
                                            padding: const EdgeInsets.only ( left: 5 ) ,
                                            child: Text (
                                              '${widget.newsModel!.xAuthor}',
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
                              ) ,
                            ] ,
                          ) ,
                          Divider ( color: Theme.of ( context ).textTheme.caption!.color ) ,

                         const SizedBox ( height: 10 ) ,

                          SizedBox (
                            child: mediumWidget ,
                            width: MediaQuery.of ( context ).size.width ,
                            height: 250,
                          ) ,

                          const SizedBox ( height: 5 ) ,

                          // NEWS DETAILS BODY
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: widget.newsModel!.articleSplit!.length,
                              itemBuilder: (BuildContext context , int index) {
                                return Html (
                                  data: widget.newsModel!.articleSplit![index].toString(),
                                  style: {
                                    "body": Style(
                                        fontSize:  FontSize(9*_fontSizeController.value),
                                        fontWeight: FontWeight.w400,
                                        color:Theme.of(context).textTheme.bodyText1!.color
                                    ),
                                  },
                                );
                              },
                              separatorBuilder: ( context, index) {
                                return index != 0 && index % 5 == 0
                                    ? Container(
                                  child: inArticleWidget,
                                  height: 100,
                                )
                                    : Container(height: 10);
                              }
                          ),

                          const SizedBox ( height: 15 ) ,

                          Container (
                            padding: const EdgeInsets.symmetric ( horizontal: 15 ) ,
                            child: Text ( "Read Also" ,
                              style: TextStyle (
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                  fontSize: 23 ,
                                  fontWeight: FontWeight.bold ) ,
                            ) ,
                          ) ,
                         const SizedBox ( height: 10 ) ,

                          //NEWS TAG
                          BlocListener<NewsTagBloc , NewsTagState> (
                            listener: (context , state) {
                              if ( state is NewsTagRefreshingState ) {
                                // Scaffold.of ( context ).showSnackBar (SnackBar (content: Text ( 'Refreshing' ) ) );
                              }
                              else if ( state is NewsTagLoadedState &&
                                  state.message != null ) {
                                // Scaffold.of ( context ).showSnackBar (SnackBar (content: Text ( '' ) ) );
                              }
                              else if ( state is NewsTagMoreLoadedState ) {
                                // Scaffold.of ( context ).showSnackBar (SnackBar (content: Text ( 'more news tag' ) ) );
                              }
                              else if ( state is NewsTagMoreFailureState ) {
                                // Scaffold.of ( context ).showSnackBar (SnackBar ( content: Text ('news tag failed to load ' ) ) );
                              }

                              else if ( state is NewsTagLoadFailureState ) {
                              }
                            } ,

                            child: BlocBuilder<NewsTagBloc , NewsTagState> (
                              buildWhen: (previous , current) {
                                // returning false here when we have a load failure state means that.
                                // we do not want the widget to rebuild when there is error
                                if ( current is NewsTagLoadFailureState ||
                                    current is NewsTagState ||
                                    current is NewsTagMoreLoadedState ||
                                    current is NewsTagMoreFailureState ||
                                    current is NewsTagLoadingMoreState )
                                  return false;
                                else
                                  return true;
                              } ,
                              builder: (context , state) {
                                if ( state is NewsTagInitialState ) {
                                  return BuildLoadingWidget ( );
                                } else if ( state is NewsTagLoadingState ) {
                                  return BuildLoadingWidget ( );
                                } else if ( state is NewsTagLoadedState ) {
                                  return buildNewsTagList ( state.newsTag );
                                } else if ( state is NewsTagLoadFailureState ) {
                                  return BuildErrorUi ( message: state.error, );
                                }
                                else {
                                  return const BuildErrorUi (message: "Something went wrong!" );
                                }
                              } ,
                            ) ,
                          ) ,

                          const SizedBox ( height: 10 ) ,

                          //FOR AD MANAGER UNITS
                          _adShown?  Center(
                              child: SizedBox(
                                width: 300,
                                height: 250,
                                child: adManagerBannerWidget,
                              ))
                              : Container(height: 0),
                        ] ,
                      ) ,
                    ) );
              }
          );
        }
    );
  }

  Widget buildNewsTagList (List<HomeNewsModel> newsTagModel){
    return ListView.builder (
      shrinkWrap: true ,
      scrollDirection: Axis.vertical ,
      physics: NeverScrollableScrollPhysics(),
      itemCount: newsTagModel.length,
      itemBuilder: (ctx, pos) {
        return Padding (
          padding:const EdgeInsets.symmetric (vertical: 5 ),
          child: Container(
            padding:const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: InkWell(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              onTap: (){
                HomeNewsModel lNM = newsTagModel[pos];
                Navigator.push ( context , MaterialPageRoute(builder: (context)=> BlocProvider<NewsTagBloc> (
                    create: (context) => NewsTagBloc (repository: Repository ()) ,
                    child: NewsDetails ( newsModel: lNM , )
                ) ,
                ));
              },

              child: Row(
                children: <Widget>[
                  Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all( Radius.circular(10), ),
                    ),
                    elevation: 4,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all( Radius.circular(10)),
                      child: Hero(
                        tag: pos,
                        child: CachedNetworkImage(
                          imageUrl: '${newsTagModel[pos].jetpackFeaturedMediaUrl}',
                          placeholder: (context, url) => const SizedBox(
                              height: 125,
                              width: 248,
                              child: Center(child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) =>
                          const Center(child: Text("Punch News")),
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox( width: 10),

                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 5),
                              child:  Text(
                                  Jiffy('${newsTagModel[pos].date}').fromNow(),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize:12, )),
                            ),
                          ],
                        ),

                        const SizedBox( width: 10),

                        Material(
                            type: MaterialType.transparency,
                            child: Html(
                              data:  '${newsTagModel[pos].title!.rendered}',
                              style: {
                                "body": Style(
                                    fontSize: const FontSize(18.0),
                                    fontWeight: FontWeight.w400,
                                    color:Theme.of(context).textTheme.bodyText1!.color
                                ),
                              },
                            )
                        ),
                        const SizedBox( height: 10),
                        SizedBox (
                          height: 25 ,
                          child: ListView.builder (
                            scrollDirection: Axis.horizontal ,
                            itemCount: 1 ,
                            shrinkWrap: true ,
                            itemBuilder: (BuildContext context , int index) {
                              return
                                Container (
                                  padding: const EdgeInsets.symmetric ( horizontal: 5 , vertical: 3 ) ,
                                  margin: const EdgeInsets.only ( right: 5.0 ) ,
                                  decoration: BoxDecoration ( borderRadius: BorderRadius.circular ( 5 ) ,
                                    color: mainColor ,
                                  ) ,
                                  child: Center (
                                    child: GestureDetector (
                                      onTap: () {} ,
                                      child:  Text (
                                        "${newsTagModel[pos].xCategories}",
                                        style: const TextStyle (fontSize: 10 , color: whiteColor) ,
                                      ) ,
                                    ) ,
                                  ) ,
                                );
                            } ,
                          ) ,
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











