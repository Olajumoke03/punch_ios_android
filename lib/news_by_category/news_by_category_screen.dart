import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:punch_ios_android/news_tag/news_tag_bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jiffy/jiffy.dart';
import 'package:punch_ios_android/category_list/model.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_bloc.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_event.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_state.dart';
import 'package:punch_ios_android/screens/news_details.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:punch_ios_android/widgets/build_error_ui.dart';
import 'package:punch_ios_android/widgets/build_loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class NewsByCategory extends StatefulWidget {
  late CategoryListModel model;
   String? id;

  NewsByCategory({Key? key, required this.model}) : super(key: key);

  @override
  _NewsByCategoryState createState() => _NewsByCategoryState();
}

class _NewsByCategoryState extends State<NewsByCategory> {
  late NewsByCategoryBloc newsByCategoryBloc;
  // final _nativeAdController = NativeAdmobController();
  late FontSizeController _fontSizeController;

  /// pagination
  List<HomeNewsModel> allNewsByCategory = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool isRefreshing=false;

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
      setState ( () {
        isLoadingMore=true;
      } );
      newsByCategoryBloc.add ( FetchMoreNewsByCategoryEvent ( page: currentPage + 1, id: widget.model.id ) );
    }
  }
  double _height =0;

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

    newsByCategoryBloc.add(RefreshNewsByCategoryEvent(id: widget.model.id));
  }
  RefreshController _refreshController = RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
    _fontSizeController = Provider.of<FontSizeController>(context, listen: false);

    newsByCategoryBloc = BlocProvider.of<NewsByCategoryBloc>(context);
    newsByCategoryBloc.add(FetchNewsByCategoryEvent(id: widget.model.id));
    // _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    //
    myBanner.load();
    secondBanner.load();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title:  Text(widget.model.name!, style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),),

      leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: mainColor,)
        ),
      ),

      body: BlocListener<NewsByCategoryBloc, NewsByCategoryState>(
        listener: (context, state){
          if ( state is NewsByCategoryRefreshingState ) {
            setRefreshing(true);
          }
          else if ( state is NewsByCategoryRefreshedState ) {

            setState(() {
              currentPage = 1;
              isRefreshing = false;
              _refreshController.refreshCompleted();
              allNewsByCategory.clear();
              allNewsByCategory = state.newsByCategory;
            });
          }
          else if ( state is NewsByCategoryLoadedState ) {
            setState(() {
              currentPage = 1;
              isRefreshing = false;
              _refreshController.refreshCompleted();
              allNewsByCategory = state.newsByCategory;
            });
            print("I reached news loaded success");

          }
          else if ( state is NewsByCategoryMoreLoadedState ) {
            setState(() {
              currentPage ++;
              isLoadingMore = false;
              _refreshController.loadComplete();
              allNewsByCategory.addAll(state.newsByCategory) ;
            });
            print("I reached pagination success");
          }
          else if ( state is NewsByCategoryMoreFailureState ) {
            setState(() {
              isLoadingMore = false;
            });
            print("I reached pagination failure");

          }
          else if ( state is NewsByCategoryLoadFailureState ) {
            setRefreshing(false);
          }else{
            setRefreshing(false);
          }
        },
        child: BlocBuilder<NewsByCategoryBloc, NewsByCategoryState>(
          buildWhen:(previous,current){
            // returning false here when we have a load failure state means that.
            // we do not want the widget to rebuild when there is error
            if(current is NewsByCategoryLoadFailureState ||
                current is NewsByCategoryRefreshingState ||
                current is NewsByCategoryMoreLoadedState || current is NewsByCategoryMoreFailureState || current is NewsByCategoryLoadingMoreState )
              return false;
            else
              return true;
          },
          builder: (context, state) {
            if ( state is NewsByCategoryInitialState ) {
              return const BuildLoadingWidget ( );
            } else if ( state is NewsByCategoryLoadingState ) {
              return const BuildLoadingWidget ( );
            } else if ( state is NewsByCategoryLoadedState ) {
              return buildNewsByCategoryList ( allNewsByCategory );
            }
            else if ( state is NewsByCategoryRefreshedState ) {
              return buildNewsByCategoryList ( allNewsByCategory );
            }
            // else if ( state is NewsByCategoryCachedNewsLoadedState ) {
            //   return buildHomeCachedNews ( state.cachedNews );
            // }
            else if (state is NewsByCategoryEmptyState){
              return  Center(child: Text(state.message, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),));
            }
            else if ( state is NewsByCategoryLoadFailureState ) {
              return BuildErrorUi (message: state.error );
            }
            else {
              return const BuildErrorUi (message: "Something went wrong!" );
            }
          },
        ),
      ),

    );
  }

  Widget buildNewsByCategoryList (List<HomeNewsModel> newsByCategoryModel){
    final AdWidget adWidget = AdWidget(ad: myBanner);
    final AdWidget secondWidget = AdWidget(ad: secondBanner);

    return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: _refreshController,
          onRefresh: refresh,
          footer: CustomFooter(
            builder: ( context, mode){
              Widget body ;
              if(isLoadingMore == false){
                body =  Text("No more news");
                print("current status of is loading more :" + isLoadingMore.toString());
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
        child: ListView.separated (
            shrinkWrap: true ,
            scrollDirection: Axis.vertical ,
            itemCount: newsByCategoryModel.length+1,
            itemBuilder: (ctx, pos) {

              if(pos == newsByCategoryModel.length) {
                return Container();
              } else {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),

                  ),
                  child: InkWell(
                    onTap: () {
                      HomeNewsModel nBC = newsByCategoryModel[pos];
                      Navigator.push( context, MaterialPageRoute(builder: (context)=>
                          BlocProvider<NewsTagBloc>(
                              create: (context) => NewsTagBloc(repository: Repository()),
                              child: NewsDetails(newsModel: nBC,)
                          ) )
                      );
                    },

                    child: Row(
                      children: <Widget>[
                        Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all( Radius.circular(10), ),
                          ),
                          elevation: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all( Radius.circular(10)),
                            child: CachedNetworkImage(
                              imageUrl:'${newsByCategoryModel[pos].jetpackFeaturedMediaUrl}',
                              placeholder: (context, url) => Container(
                                  height: 125,
                                  width: 248,
                                  child: Center(child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) =>
                              const Center(child: Text("Punch News")),

                              //     Image.asset("assets/punchLogo.png",
                              //   fit: BoxFit.contain,
                              //   height: 100,
                              //   width: 100,
                              // ),
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
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
                                    data:  '${newsByCategoryModel[pos].title!.rendered}',
                                    style: {
                                      "body": Style(
                                          fontSize: const FontSize(18.0),
                                          fontWeight: FontWeight.w400,
                                          color:Theme.of(context).textTheme.bodyText1!.color
                                      ),
                                    },
                                  )
                              ),
                              const SizedBox( height: 20),
                              Row(
                                children: <Widget>[
                                  Container(
                                    constraints: const BoxConstraints( maxWidth: 120),
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: mainColor,
                                    ),
                                    child: Text (
                                      "${newsByCategoryModel[pos].xCategories}",
                                      style: TextStyle ( fontSize: 5*_fontSizeController.value , color:Colors.white ,
                                      ) ,
                                    ),
                                  ),

                                 const  Spacer(),

                                  Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                        Jiffy('${newsByCategoryModel[pos].date}').fromNow(),
                                      // '${newsByCategoryModel[pos].xDate}',
                                      //   Constants.readTimestamp(newsByCategoryModel[pos].date),
                                        style: TextStyle( fontSize: 4*_fontSizeController.value, color: Theme.of(context).textTheme.bodyText1!.color,)),
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
            } ,

            separatorBuilder: ( context, index) {
              // return index != 2 && index % 6 == 0
              return index % 5 == 0
                  ? Container(
                  margin: EdgeInsets.symmetric( vertical: 5),
                  child: index % 10 == 0 ?
                  Container(
                    child: adWidget, height: 100,
                  )
                      :Container( child: secondWidget , height: 100, )
              )
                  : Container(height: 10);
            }
        ),
    );
  }

}

