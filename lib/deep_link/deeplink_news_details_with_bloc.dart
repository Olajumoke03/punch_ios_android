import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:punch_ios_android/deep_link/deep_link_details_event.dart';
import 'package:punch_ios_android/deep_link/deep_link_details_state.dart';
import 'package:punch_ios_android/deep_link/deeplink_details_bloc.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/screens/font_test.dart';
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

 final String? slug;

  const DeepLinkNewsDetailsBloc ({Key? key , required this.slug,}) : super( key: key );

  @override
  _DeepLinkNewsDetailsBlocState createState() => _DeepLinkNewsDetailsBlocState();
}

class _DeepLinkNewsDetailsBlocState extends State<DeepLinkNewsDetailsBloc> {

  bool isSaved=false;
  late DeepLinkDetailsBloc _deepDetailsProvider;
  late HomeNewsModel homeNewsModel;
  late FontSizeController _fontSizeController;

  final Completer<WebViewController> _controller = Completer<WebViewController>();

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
  }


  fontDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
          child: const  ChangeTextSizeWithSeekBar()
      ),
    );
  }
  @override
  Widget build (BuildContext context) {
    final AdWidget mediumWidget = AdWidget(ad: articleMedium);
    final AdWidget inArticleWidget = AdWidget(ad: inArticleAds);

    return Consumer<FontSizeController>(
      builder: (context, fontScale, child) {
        return Consumer<DeepLinkNewsDetailsProvider>(
            builder: ( context,  deepProvider,  child) {
          HomeNewsModel newsModel = deepProvider.getNewsDetails();
          return Consumer<DetailsProvider>(
              builder: ( context,  detailsProvider,  child) {

        return Scaffold (
            appBar: AppBar (
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.headline1!.color,)
              ),
              title:  Text("Punch News", style: TextStyle(color: Theme.of(context).textTheme.headline1!.color, fontWeight: FontWeight.w500),),
              centerTitle: true,
              actions: <Widget>[
                Visibility(
                  visible: deepProvider.isLoadSuccessful==true,
                  child: IconButton (
                    onPressed: () {
                      fontDialog ( );
                    } ,
                    icon: Icon (
                      Icons.text_fields ,
                      color: Theme.of(context).textTheme.headline1!.color,
                    ) ,
                  ),
                ) ,

                Visibility(
                  visible: deepProvider.isLoadSuccessful==true,
                  child: IconButton (
                    onPressed: () {
                      FlutterShare.share(
                        title: 'Punch News' ,
                        text: 'Read: ' '${newsModel.title!.rendered}' ', on Punch News' .replaceAll (r"\n" , "\n" )
                            .replaceAll ( r"\r" , "" ).replaceAll ( r"\'" , "'" ).replaceAll ( "<p>" , "" ).replaceAll ("&#8217;" , "'" )
                            .replaceAll ("&#038;" , "&" ).replaceAll ("&#8216;" , "‘" ),
                        linkUrl:'https:// punchng.com/' '${newsModel.slug} ',
                        chooserTitle: 'Something for chooser title',
                      );
                    } ,
                    icon: Icon (
                      Icons.share ,color: Theme.of(context).textTheme.headline1!.color,
                    ) ,
                  ),
                ) ,
              ] ,
            ) ,

            body:  BlocListener<DeepLinkDetailsBloc, DeepLinkDetailsState>(
                listener: (context, state) {
                if ( state is DeepLinkDetailsLoadedState ) {
                  deepProvider.setLoadSuccess(true);
                  deepProvider.setNewsDetails(state.model);
                  detailsProvider.checkFav(state.model.id!).then((value) {
                    setState(() {
                      isSaved = value;
                    });
                  });
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
                      padding: EdgeInsets.symmetric ( horizontal: 10 ) ,
                      children: <Widget>[
                        Stack (
                          alignment: Alignment.center ,
                          children: <Widget>[
                            ClipRRect (
                              borderRadius: const BorderRadius.all (Radius.circular ( 10.0 ) , ) ,
                              child: CachedNetworkImage (
                                imageUrl: '${state.model.jetpackFeaturedMediaUrl}' ,
                                placeholder: (context , url) =>
                                    const Center (
                                    child: CircularProgressIndicator ( ) , ) ,
                                errorWidget: (context , url , error) =>
                                const Text(" Punch News  "),
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
                            const SizedBox ( height: 9 , ) ,
                            Align(
                              alignment: Alignment.topRight,
                              child: Container (
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

                            const SizedBox  ( height: 9 , ) ,

                            Row (
                              children: [
                                SizedBox (
                                  height: 25 ,
                                  child: ListView.builder (
                                    scrollDirection: Axis.horizontal ,
                                    itemCount: 1 ,
                                    shrinkWrap: true ,
                                    itemBuilder: (BuildContext context, int index) {
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
                                                "${state.model.xCategories}",
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
                                  padding: EdgeInsets.only ( left: 5 ) ,
                                  child: Text (
                                      Jiffy('${state.model.date}').fromNow(),
                                      maxLines: 2 ,
                                      style: TextStyle (fontSize: 12, color: Theme.of(context).textTheme.bodyText1!.color,
                                      ) ) ,
                                ) ,

                              ] ,
                            ) ,
                            const SizedBox ( height: 5 ) ,

                            Material (
                                type: MaterialType.transparency ,
                                child: Html(
                                  data:  '${state.model.title!.rendered}',
                                  style: {
                                    "body": Style(
                                        fontSize:  FontSize(9*_fontSizeController.value),
                                        fontWeight: FontWeight.w400,
                                        color:Theme.of(context).textTheme.bodyText1!.color
                                    ),
                                  },
                                )
                            ) ,
                          ] ,
                        ),

                        Divider ( color: Theme.of ( context ).textTheme.caption!.color ) ,

                        const SizedBox ( height: 15 ) ,

                        Container (
                          child: mediumWidget ,
                          width: MediaQuery.of ( context ).size.width ,
                          height: 250,
                        ) ,

                        //NEWS DETAILS BODY
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: state.model.articleSplit!.length,
                            itemBuilder: (BuildContext context , int index) {
                              return Html (
                                data: state.model.articleSplit![index].toString(),
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

                         SizedBox (
                          child: mediumWidget ,
                          width: MediaQuery.of ( context ).size.width ,
                          height: 250,
                        ) ,

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


