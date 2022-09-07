

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/utility/constants.dart';
import 'package:punch_ios_android/utility/favorites_provider.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';



class SavedNewsScreen extends StatefulWidget {
  @override
  _SavedNewsScreenState createState() => _SavedNewsScreenState();
}

class _SavedNewsScreenState extends State<SavedNewsScreen> {
  FontSizeController? _fontSizeController;

  @override
  void initState() {
    super.initState();
    _fontSizeController = Provider.of<FontSizeController>(context, listen: false);
    FavoritesProvider _favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    _favoritesProvider.getFeed();

  }
  @override
  Widget build(BuildContext context) {

    return Consumer<FavoritesProvider>(
      builder: ( context,  favoritesProvider,  child) {

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyText1!.color,)
            ),
            title: Text( "Saved News",style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500), ),
          ),

          body: favoritesProvider.posts.isEmpty
              ? Center(
            child: Text( "You don't have any saved news", style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold,color: Theme.of(context).textTheme.bodyText1!.color
              ),
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            shrinkWrap: true,
            itemCount: favoritesProvider.posts.length,

            itemBuilder: (BuildContext context, int index) {
              HomeNewsModel newsModel = HomeNewsModel.fromJson(favoritesProvider.posts[index]["item"]);
              return buildSavedNews(newsModel);

            },
          ),
        );
      },
    );



  }
  Widget buildSavedNews(HomeNewsModel newsModel){
    final uuid = Uuid();
    final String imgTag = uuid.v4();
    return Padding (
      padding: EdgeInsets.symmetric (vertical: 5 ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).textTheme.bodyText2!.color,
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
            // Navigator.push ( context ,
            //  BlocProvider<NewsTagBloc> (
            //         create: (context) => NewsTagBloc (newsTagRepository: NewsRepository ()) ,
            //         child: NewsDetails ( newsModel: newsModel , )
            //     ) ,
            // );

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
                    tag: imgTag,
                    child: CachedNetworkImage(
                      //imageUrl: "$img",
                      imageUrl: '${newsModel.jetpackFeaturedMediaUrl}',
                      placeholder: (context, url) => Container(
                          height: 125,
                          width: 248,
                          child: Center(child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) =>
                      //     Image.asset(
                      //   "assets/images/place.png",
                      //   fit: BoxFit.cover,
                      //   height: 100,
                      //   width: 100,
                      // ),
                       Text(" Punch News  "),
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
                          data:  '${newsModel.title!.rendered}',
                          style: {
                            "body": Style(
                                fontSize: const FontSize(18.0),
                                fontWeight: FontWeight.w400,
                                color:Theme.of(context).textTheme.bodyText1!.color
                            ),
                          },
                        )
                    ),
                              SizedBox( height: 15),

                    SizedBox( height: 3),
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
                              // // CategoryListModel cLM = categoryListModel[pos];
                              // CategoryListModel cLM = CategoryListModel ( );
                              // cLM.categoryId = newsModel.categories[0].toString ( );
                              // cLM.categoryName = newsModel.categoriesString[0];
                              //
                              // Navigator.push ( context ,
                              //   PageTransition (
                              //     type: PageTransitionType.rightToLeft ,
                              //     // child: NewsCategoryList(model:newsByCategoryModel[pos]),
                              //     child: BlocProvider<NewsByCategoryBloc> (
                              //         create: (context) => NewsByCategoryBloc (newsByCategoryRepository: NewsRepository ()) ,
                              //         child: NewsByCategory ( model: cLM , )
                              //     ) ,
                              //   ) ,
                              // );
                            } ,
                            // child: Text (
                            //   '${ newsModel.categoriesString[0].replaceAll("&amp;", "&")}' ,
                            //   // "${newsByCategoryModel.xCategories}",
                            //   style: TextStyle ( fontSize:  5*_fontSizeController.value , color:Colors.white,
                            //   ) ,
                            // ) ,
                          ) ,

                        ),

                        Spacer(),

                                  Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                        // '${newsModel.date}',
                                        Jiffy(newsModel.date).fromNow(),
                              style: TextStyle( fontSize: 4*_fontSizeController!.value, color: Theme.of(context).textTheme.bodyText1!.color,)),
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
}
