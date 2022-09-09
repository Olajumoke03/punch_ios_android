import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:punch_ios_android/category_list/bloc.dart';
import 'package:punch_ios_android/category_list/event.dart';
import 'package:punch_ios_android/category_list/model.dart';
import 'package:punch_ios_android/category_list/state.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_screen.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/search_result/search_result.dart';
import 'package:punch_ios_android/search_result/search_result_bloc.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:provider/provider.dart';


class CategoryListScreen extends StatefulWidget {
  late CategoryListModel categoryListModel;

   CategoryListScreen({Key? key}) : super(key: key);

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  late CategoryListBloc categoryListBloc;
  late CategoryListModel categoryListModel;
  late FontSizeController _fontSizeController;

  String _searchQuery= 'a';

  @override
  void initState() {
    super.initState();
    _fontSizeController = Provider.of<FontSizeController>(context, listen: false);
    categoryListBloc = BlocProvider.of<CategoryListBloc>(context);
    categoryListBloc.add(FetchCategoryListEvent());
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeController>(
        builder: ( context,  fontScale,
             child) {

          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Image.asset(
                    'assets/punchLogo.png', width: 100, height: 40),
              ),

              body: SingleChildScrollView(
                child: Column(
                  children: [
                    getSearchBarUI(context),

                    SizedBox(height: 10,),

                    BlocListener<CategoryListBloc, CategoryListState>(
                      listener: (context, state) {
                        if (state is CategoryListRefreshingState) {
                          // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Refreshing')));
                        }
                        else if (state is CategoryListLoadedState &&
                            state.message != null) {
                          // a message will only come when it is updating the feed.
                        }
                        else if (state is CategoryListLoadFailureState) {
                        }
                      },
                      child: BlocBuilder<CategoryListBloc, CategoryListState>(
                        builder: (context, state) {
                          if (state is CategoryListInitialState) {
                            return buildLoading();
                          } else if (state is CategoryListLoadingState) {
                            return buildLoading();
                          } else if (state is CategoryListLoadedState) {
                            return buildCategoryList(state.categoryList);
                          } else if (state is CategoryListLoadFailureState) {
                            return buildErrorUi(state.error);
                          }
                          else {
                            return buildErrorUi("Something went wrong!");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            );
        }
    );
  }

  Widget buildLoading ( ) {
    return const Center (
      child: CircularProgressIndicator ( ) ,
    );
  }

  Widget buildErrorUi ( String message ) {
    return Center (
      child: Text ( message , style: const TextStyle ( color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20 ) ,
      ) ,
    );
  }

  Widget buildCategoryList (List<CategoryListModel> categoryListModel){
    return GridView.builder (
      padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: categoryListModel.length,
      shrinkWrap: true ,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, pos) {
        return GestureDetector(
          onTap: () {
            CategoryListModel cLM = categoryListModel[pos];
            Navigator.push( context, MaterialPageRoute(builder: (context)=>
                BlocProvider<NewsByCategoryBloc>(
                    create: (context) => NewsByCategoryBloc(repository: Repository()),
                    child: NewsByCategory(model: cLM,)
                ) )
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).textTheme.button!.color,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column (
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: "${categoryListModel[pos].imageUrl}",
                  color: Theme.of(context).accentColor,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                      child: SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator())),
                  errorWidget: (context, url, error) => Container(
                    color: Theme.of(context).accentColor,
                    height: 20,
                    width: 20,
                  ),
                ),
               const SizedBox(height: 10,),
                Text(
                  "${categoryListModel[pos].categoryName}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    // fontSize: 5.2*_fontSizeController.value,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
              ],
            ),
          ),
        );
      } ,
    );
  }

  Widget getSearchBarUI(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( bottom:10.0),
      padding: const EdgeInsets.all( 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push( context, MaterialPageRoute(builder: (context)=>
              BlocProvider<SearchResultBloc>(
                  create: (context) => SearchResultBloc(repository: Repository()),
                  child: SearchResult(searchQuery: _searchQuery)
              ) )
          );
        },
        child: Container(
          padding: const EdgeInsets.only(top:3.0, bottom:3.0),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: const BorderRadius.all( Radius.circular(25.0), ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only( left: 20, right: 16, top: 3, bottom: 3),
                    child: Text(
                      "Search News...",
                      style: TextStyle( fontSize: 15, color: Theme.of(context).textTheme.bodyText1!.color ),
                    ),
                  )
              ),
              Container(
                width:45,
                height:45,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Material(
                    color: Colors.transparent,
                    child: Center(
                      child: Icon(Icons.search,
                          size: 22,
                          color: Colors.white
                      ),)

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}



