// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:provider/provider.dart';
// import 'package:punch_ios_android/category_list/model.dart';
// import 'package:punch_ios_android/home_news/home_model.dart';
// import 'package:punch_ios_android/news_by_category/news_by_category_bloc.dart';
// import 'package:punch_ios_android/news_by_category/news_by_category_screen.dart';
// import 'package:punch_ios_android/news_tag/news_tag_bloc.dart';
// import 'package:punch_ios_android/repository/news_repository.dart';
// import 'package:punch_ios_android/screens/news_details.dart';
// import 'package:punch_ios_android/utility/constants.dart';
// import 'package:punch_ios_android/utility/favorites_provider.dart';
// import 'package:punch_ios_android/utility/font_controller.dart';
//
// import 'package:uuid/uuid.dart';
//
//
// class SavedNewsScreen extends StatefulWidget {
//   const SavedNewsScreen({Key? key}) : super(key: key);
//
//   @override
//   _SavedNewsScreenState createState() => _SavedNewsScreenState();
// }
//
// class _SavedNewsScreenState extends State<SavedNewsScreen> {
//   late FontSizeController _fontSizeController;
//   late FavoritesProvider _favoritesProvider;
//   @override
//   void initState() {
//     super.initState();
//     _fontSizeController = Provider.of<FontSizeController>(context, listen: false);
//     _favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
//     // FavoritesProvider _favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
//
//     _favoritesProvider.getFeed();
//
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     return Consumer<FavoritesProvider>(
//       builder: ( context,  favoritesProvider,  child) {
//         return Scaffold(
//           backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//           appBar: AppBar(
//             centerTitle: true,
//             leading: Container(
//               alignment: Alignment.center,
//             ),
//             title: Text( "Saved News", style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color, fontWeight: FontWeight.bold, fontSize: 18),),
//
//         ),
//
//           body: favoritesProvider.posts.isEmpty
//               ? Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Image.asset(
//                   "assets/images/empty.png",
//                   height: 200,
//                   width: 200,
//                 ),
//                 Text( "You don't have any saved news",
//                   style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 20, fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           )
//               : ListView.builder(
//             padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
//             shrinkWrap: true,
//             itemCount: favoritesProvider.posts.length,
//             itemBuilder: (BuildContext context, int index) {
//               HomeNewsModel newsModel = HomeNewsModel.fromJson(favoritesProvider.posts[index]["item"]);
//               return buildSavedNews(newsModel);
//             },
//           ),
//
//         );
//       },
//     );
//
//   }
//   Widget buildSavedNews(HomeNewsModel newsModel){
//     final uuid = Uuid();
//     final String imgTag = uuid.v4();
//     return Padding (
//       padding: EdgeInsets.symmetric (vertical: 5 ),
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//         decoration: BoxDecoration(
//           color: Theme.of(context).textTheme.bodyText2!.color,
//           boxShadow: [
//             BoxShadow(
//                 color: Theme.of(context).focusColor.withOpacity(0.1),
//                 blurRadius: 5,
//                 offset: Offset(0, 2)),
//           ],
//         ),
//         child: InkWell(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10),
//             topRight: Radius.circular(10),
//           ),
//           onTap: (){
//             Navigator.push ( context , MaterialPageRoute(builder: (context)=>
//                 BlocProvider<NewsTagBloc> (
//                     create: (context) => NewsTagBloc (repository: Repository ()) ,
//                     child: NewsDetails ( newsModel: newsModel , )
//                 ) ,
//             ));
//           },
//           child: Row(
//             children: <Widget>[
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all( Radius.circular(10), ),
//                 ),
//                 elevation: 4,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.all( Radius.circular(10)),
//                   child: Hero(
//                     tag: imgTag,
//                     child: CachedNetworkImage(
//                       //imageUrl: "$img",
//                       imageUrl: '${newsModel.xFeaturedMedia}',
//                       placeholder: (context, url) => Container(
//                           height: 125,
//                           width: 248,
//                           child: Center(child: CircularProgressIndicator())),
//                       errorWidget: (context, url, error) => Image.asset(
//                         "assets/images/place.png",
//                         fit: BoxFit.cover,
//                         height: 100,
//                         width: 100,
//                       ),
//                       fit: BoxFit.cover,
//                       height: 100,
//                       width: 100,
//                     ),
//                   ),
//                 ),
//               ),
//
//               SizedBox( width: 10),
//
//               Flexible(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Hero(
//                       tag: newsModel.title!.rendered!,
//                       child: Material(
//                         type: MaterialType.transparency,
//                         child:
//                         // Html(
//                         //   data :newsModel.title!.rendered!,
//                         //   useRichText: true,
//                         //   renderNewlines: true,
//                         //   defaultTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize:  8*_fontSizeController.value,  fontWeight:FontWeight.w500),
//                         // ),
//                         Html(
//                           data:  newsModel.title!.rendered!,
//                           style: {
//                             "body": Style(
//                                 fontSize: const FontSize(18.0),
//                                 fontWeight: FontWeight.w500,
//                                 color:Theme.of(context).textTheme.bodyText1!.color
//                             ),
//                           },
//                         )
//                                 ),
//                               ),
//                               SizedBox( height: 15),
//
//                     SizedBox( height: 3),
//                     Row(
//                       children: <Widget>[
//                         Container(
//                           constraints: BoxConstraints( maxWidth: 100),
//                           padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: Theme.of(context).colorScheme.secondary,
//                           ),
//                           child: GestureDetector (
//                             onTap: () {
//                               CategoryListModel cLM = CategoryListModel ( );
//                               cLM.categoryId = newsModel.categories![0].toString ( );
//                               cLM.categoryName = newsModel.categoriesString![0];
//
//                               Navigator.push ( context , MaterialPageRoute(builder: (context)=>
//                                   BlocProvider<NewsByCategoryBloc> (
//                                       create: (context) => NewsByCategoryBloc (repository: Repository ()) ,
//                                       child: NewsByCategory ( model: cLM , )
//                                   ) ,
//                               ));
//                             } ,
//                             child: Text (
//                               '${ newsModel.categoriesString![0].replaceAll("&amp;", "&")}' ,
//                               style: TextStyle ( fontSize:  6*_fontSizeController.value , color: Colors.white ,
//                               ) ,
//                             ) ,
//                           ) ,
//
//                         ),
//                         Spacer(),
//                                   Container(
//                                     padding: EdgeInsets.only(left: 5),
//                                     child: Text(
//                                         Constants.readTimestamp(newsModel.date!),
//                               style: TextStyle( fontSize: 4*_fontSizeController.value,
//                                 color: Theme.of(context).textTheme.bodyText1!.color,
//                               )),
//                         ),
//
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// //
// // class SavedNewsScreen extends StatefulWidget {
// //   const SavedNewsScreen({Key? key}) : super(key: key);
// //
// //   @override
// //   State<SavedNewsScreen> createState() => _SavedNewsScreenState();
// // }
// //
// // class _SavedNewsScreenState extends State<SavedNewsScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container();
// //   }
// // }


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:punch_ios_android/category_list/model.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_bloc.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_screen.dart';
import 'package:punch_ios_android/news_tag/news_tag_bloc.dart';
import 'package:punch_ios_android/screens/news_details.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/utility/favorites_provider.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:uuid/uuid.dart';

import '../repository/news_repository.dart';
import '../utility/constants.dart';


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
            title: Image.asset(
                'assets/punchLogo.png', width: 100, height: 40),
          ),

          body: favoritesProvider.posts.isEmpty
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  "assets/images/empty.png",
                  height: 200,
                  width: 200,
                ),
                Text( "You don't have any saved news",
                  style: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 20, fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            shrinkWrap: true,
            reverse: true,
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
          Navigator.push ( context , MaterialPageRoute(builder: (context)=>
              BlocProvider<NewsTagBloc> (
                  create: (context) => NewsTagBloc (repository: Repository ()) ,
                  child: NewsDetails ( newsModel: newsModel , )
              ) ,
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
              child: Hero(
                tag: imgTag,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: '${newsModel.xFeaturedMedia}',
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
                        data: '${newsModel.title!.rendered}',
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
                            CategoryListModel cLM = CategoryListModel ( );
                            cLM.categoryId = newsModel.categories![0].toString ( );
                            cLM.categoryName = newsModel.categoriesString![0];

                            Navigator.push ( context , MaterialPageRoute(builder: (context)=>
                                BlocProvider<NewsByCategoryBloc> (
                                    create: (context) => NewsByCategoryBloc (repository: Repository ()) ,
                                    child: NewsByCategory ( model: cLM , )
                                ) ,
                            ));
                          },
                          child: Text(
                            newsModel.categoriesString![0].replaceAll("&amp;", "&"),
                            style: TextStyle(
                              fontSize: 4.5 * _fontSizeController!.value,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                            Jiffy('${newsModel.date}').fromNow(),
                            style: TextStyle(
                                fontSize: 4 * _fontSizeController!.value,
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

    //   Padding (
    //   padding: EdgeInsets.symmetric (vertical: 5 ),
    //   child: Container(
    //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    //     decoration: BoxDecoration(
    //       color: Theme.of(context).textTheme.bodyText2!.color,
    //       boxShadow: [
    //         BoxShadow(
    //             color: Theme.of(context).focusColor.withOpacity(0.1),
    //             blurRadius: 5,
    //             offset: Offset(0, 2)),
    //       ],
    //     ),
    //     child: InkWell(
    //       borderRadius: const BorderRadius.only(
    //         topLeft: Radius.circular(10),
    //         topRight: Radius.circular(10),
    //       ),
    //       onTap: (){
    //         Navigator.push ( context , MaterialPageRoute(builder: (context)=>
    //             BlocProvider<NewsTagBloc> (
    //                 create: (context) => NewsTagBloc (repository: Repository ()) ,
    //                 child: NewsDetails ( newsModel: newsModel , )
    //             ) ,
    //         ));
    //       },
    //       child: Row(
    //         children: <Widget>[
    //           Card(
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.all( Radius.circular(10), ),
    //             ),
    //             elevation: 4,
    //             child: ClipRRect(
    //               borderRadius: BorderRadius.all( Radius.circular(10)),
    //               child: Hero(
    //                 tag: imgTag,
    //                 child: CachedNetworkImage(
    //                   //imageUrl: "$img",
    //                   imageUrl: '${newsModel.xFeaturedMedia}',
    //                   placeholder: (context, url) => Container(
    //                       height: 125,
    //                       width: 248,
    //                       child: Center(child: CircularProgressIndicator())),
    //                   errorWidget: (context, url, error) => Image.asset(
    //                     "assets/images/place.png",
    //                     fit: BoxFit.cover,
    //                     height: 100,
    //                     width: 100,
    //                   ),
    //                   fit: BoxFit.cover,
    //                   height: 100,
    //                   width: 100,
    //                 ),
    //               ),
    //             ),
    //           ),
    //
    //           SizedBox( width: 10),
    //
    //           Flexible(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.max,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 Hero(
    //                   tag: newsModel.title!.rendered!, //the.rendered nko
    //                   child: Material(
    //                     type: MaterialType.transparency,
    //                     child:
    //                     Html(
    //                       data:  newsModel.title!.rendered!,
    //                       style: {
    //                         "body": Style(
    //                             fontSize: const FontSize(18.0),
    //                             fontWeight: FontWeight.w500,
    //                             color:Theme.of(context).textTheme.bodyText1!.color
    //                         ),
    //                       },
    //                     )
    //                     // Html(
    //                     //   data : newsModel.title!.rendered!,
    //                     //   useRichText: true,
    //                     //   renderNewlines: true,
    //                     //   defaultTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize:  8*_fontSizeController.value,  fontWeight:FontWeight.w500),
    //                     // ),
    //                   ),
    //                 ),
    //                 SizedBox( height: 15),
    //
    //                 SizedBox( height: 3),
    //                 Row(
    //                   children: <Widget>[
    //                     Container(
    //                       constraints: BoxConstraints( maxWidth: 100),
    //                       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(5),
    //                         color: Theme.of(context).accentColor,
    //                       ),
    //                       child: GestureDetector (
    //                         onTap: () {
    //                           CategoryListModel cLM = CategoryListModel ( );
    //                           cLM.categoryId = newsModel.categories![0].toString ( );
    //                           cLM.categoryName = newsModel.categoriesString![0];
    //
    //                           Navigator.push ( context , MaterialPageRoute(builder: (context)=>
    //                               BlocProvider<NewsByCategoryBloc> (
    //                                   create: (context) => NewsByCategoryBloc (repository: Repository ()) ,
    //                                   child: NewsByCategory ( model: cLM , )
    //                               ) ,
    //                           ));
    //                         } ,
    //                         child: Text (
    //                           newsModel.categoriesString![0].replaceAll("&amp;", "&") ,
    //                           style: TextStyle ( fontSize:  6*_fontSizeController!.value , color: Colors.white ,
    //                           ) ,
    //                         ) ,
    //                       ) ,
    //
    //                     ),
    //                     Spacer(),
    //                     Container(
    //                       padding: EdgeInsets.only(left: 5),
    //                       child: Text(
    //                           Constants.readTimestamp(newsModel.date!),
    //                           style: TextStyle( fontSize: 4*_fontSizeController!.value,
    //                             color: Theme.of(context).textTheme.bodyText1!.color,
    //                           )),
    //                     ),
    //
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  // Widget buildSavedNews(HomeNewsModel newsModel){
  //   final uuid = Uuid();
  //   final String imgTag = uuid.v4();
  //   return Padding (
  //     padding: EdgeInsets.symmetric (vertical: 5 ),
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: Theme.of(context).textTheme.bodyText2!.color,
  //         boxShadow: [
  //           BoxShadow(
  //               color: Theme.of(context).focusColor.withOpacity(0.1),
  //               blurRadius: 5,
  //               offset: Offset(0, 2)),
  //         ],
  //       ),
  //       child: InkWell(
  //         borderRadius: const BorderRadius.only(
  //           topLeft: Radius.circular(10),
  //           topRight: Radius.circular(10),
  //         ),
  //         onTap: (){
  //           Navigator.push ( context , MaterialPageRoute(builder: (context)=>
  //               BlocProvider<NewsTagBloc> (
  //                   create: (context) => NewsTagBloc (repository: Repository ()) ,
  //                   child: NewsDetails ( newsModel: newsModel , )
  //               ) ,
  //           ));
  //         },
  //         child: Row(
  //           children: <Widget>[
  //             Card(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.all( Radius.circular(10), ),
  //               ),
  //               elevation: 4,
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.all( Radius.circular(10)),
  //                 child: Hero(
  //                   tag: imgTag,
  //                   child: CachedNetworkImage(
  //                     //imageUrl: "$img",
  //                     imageUrl: '${newsModel.xFeaturedMedia}',
  //                     placeholder: (context, url) => Container(
  //                         height: 125,
  //                         width: 248,
  //                         child: Center(child: CircularProgressIndicator())),
  //                     errorWidget: (context, url, error) => Image.asset(
  //                       "assets/images/place.png",
  //                       fit: BoxFit.cover,
  //                       height: 100,
  //                       width: 100,
  //                     ),
  //                     fit: BoxFit.cover,
  //                     height: 100,
  //                     width: 100,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //
  //             SizedBox( width: 10),
  //
  //             Flexible(
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.max,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   Hero(
  //                     tag: newsModel.title!.rendered!, //the.rendered nko
  //                     child: Material(
  //                       type: MaterialType.transparency,
  //                       child:
  //                       Html(
  //                         data:  newsModel.title!.rendered!,
  //                         style: {
  //                           "body": Style(
  //                               fontSize: const FontSize(18.0),
  //                               fontWeight: FontWeight.w500,
  //                               color:Theme.of(context).textTheme.bodyText1!.color
  //                           ),
  //                         },
  //                       )
  //                       // Html(
  //                       //   data : newsModel.title!.rendered!,
  //                       //   useRichText: true,
  //                       //   renderNewlines: true,
  //                       //   defaultTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1.color, fontSize:  8*_fontSizeController.value,  fontWeight:FontWeight.w500),
  //                       // ),
  //                     ),
  //                   ),
  //                   SizedBox( height: 15),
  //
  //                   SizedBox( height: 3),
  //                   Row(
  //                     children: <Widget>[
  //                       Container(
  //                         constraints: BoxConstraints( maxWidth: 100),
  //                         padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
  //                         decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(5),
  //                           color: Theme.of(context).accentColor,
  //                         ),
  //                         child: GestureDetector (
  //                           onTap: () {
  //                             CategoryListModel cLM = CategoryListModel ( );
  //                             cLM.categoryId = newsModel.categories![0].toString ( );
  //                             cLM.categoryName = newsModel.categoriesString![0];
  //
  //                             Navigator.push ( context , MaterialPageRoute(builder: (context)=>
  //                                 BlocProvider<NewsByCategoryBloc> (
  //                                     create: (context) => NewsByCategoryBloc (repository: Repository ()) ,
  //                                     child: NewsByCategory ( model: cLM , )
  //                                 ) ,
  //                             ));
  //                           } ,
  //                           child: Text (
  //                             newsModel.categoriesString![0].replaceAll("&amp;", "&") ,
  //                             style: TextStyle ( fontSize:  6*_fontSizeController!.value , color: Colors.white ,
  //                             ) ,
  //                           ) ,
  //                         ) ,
  //
  //                       ),
  //                       Spacer(),
  //                       Container(
  //                         padding: EdgeInsets.only(left: 5),
  //                         child: Text(
  //                             Constants.readTimestamp(newsModel.date!),
  //                             style: TextStyle( fontSize: 4*_fontSizeController!.value,
  //                               color: Theme.of(context).textTheme.bodyText1!.color,
  //                             )),
  //                       ),
  //
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
