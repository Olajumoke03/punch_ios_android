import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:punch_ios_android/deep_link/deeplink_details_bloc.dart';
import 'package:punch_ios_android/deep_link/deeplink_news_details_with_bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/search_result/search_model.dart';
import 'package:punch_ios_android/search_result/search_result_bloc.dart';
import 'package:punch_ios_android/search_result/search_result_event.dart';
import 'package:punch_ios_android/search_result/search_result_state.dart';
import 'package:punch_ios_android/utility/colors.dart';
import 'package:punch_ios_android/utility/font_controller.dart';
import 'package:punch_ios_android/widgets/build_error_ui.dart';
import 'package:punch_ios_android/widgets/build_loading_widget.dart';
import 'package:provider/provider.dart';


class SearchResult extends StatefulWidget{
 final String searchQuery;
  final String? slug;

  const SearchResult({Key? key, required this.searchQuery,  this.slug}): super(key:key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
 late SearchResultBloc searchResultBloc;
  FontSizeController? fontSizeController;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fontSizeController = Provider.of<FontSizeController>(context, listen: false);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        title: Image.asset ( 'assets/punchLogo.png' , width: 100 , height: 40 ) ,
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).textTheme.bodyText1!.color,)
        ),
    ),

      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            color: Colors.transparent,
            child: searchBar(),
          ),

          BlocListener<SearchResultBloc, SearchResultState>(
            listener: (context, state){
              if ( state is SearchResultRefreshingState ) {

              } else if ( state is SearchResultLoadedState && state.message != null ) {
                // a message will only come when it is updating the feed.

              }
              else if (state is SearchResultEmptyState){

              }
              else if ( state is SearchResultLoadFailureState ) {

              }
            },
            child: BlocBuilder<SearchResultBloc, SearchResultState>(
              builder: (context, state) {
                if ( state is SearchResultInitialState ) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(height: 200,),
                        Text(
                        "Your search result will appear here",
                          style: TextStyle( fontSize: 20, fontWeight: FontWeight.w500,color: Theme.of(context).textTheme.bodyText1!.color
                          ),
                        ),
                      ],
                    ),
                  );
                } else if ( state is SearchResultLoadingState ) {
                  return const BuildLoadingWidget ( );
                } else if ( state is SearchResultLoadedState ) {
                  return buildSearchResultList ( state.searchResult );
                } else if ( state is SearchResultLoadFailureState ) {
                  return BuildErrorUi (message: state.error );
                }else if (state is SearchResultEmptyState){
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                    child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color:Theme.of(context).textTheme.bodyText1!.color, fontSize: 18.0, fontStyle: FontStyle.italic),),
                        )),
                  );
                }
                else {
                  return const BuildErrorUi (message: "Something went wrong!" );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  //FOR SEARCH RESULT
  Widget buildSearchResultList (List<SearchResultModel> searchResultModel){
    return Expanded(
      child: ListView.builder(
          padding: const EdgeInsets.symmetric ( horizontal: 10 ) ,
          scrollDirection: Axis.vertical ,
          itemCount: searchResultModel.length,
          shrinkWrap: true ,
          physics: const NeverScrollableScrollPhysics(),
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
                    SearchResultModel sRM = searchResultModel[pos];
                    Navigator.push( context,
                        MaterialPageRoute(builder: (context) => BlocProvider<DeepLinkDetailsBloc>(
                            create: (context) => DeepLinkDetailsBloc(repository: Repository()),
                            child: DeepLinkNewsDetailsBloc(slug: searchResultModel[pos].url!.replaceAll("https://punchng.com/", "").replaceAll("/", ""))

                        ))
                    );
                    print("search result slug " + searchResultModel[pos].url!);
                  },
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            const SizedBox( width: 10),
                            Material(
                                type: MaterialType.transparency,
                                child: Html(
                                  data:  '${searchResultModel[pos].title}',
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

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
      )
    );
  }

  Widget searchBar(){
    return  Row(
      children: <Widget>[
        //search text
        Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, top: 10, bottom: 5, left: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 5.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only( left: 16, right: 16, top: 3, bottom: 3),
                  child: TextField(
                    autofocus: true,
                    controller: searchController,
                    onChanged: (String txt) {},
                    style: const TextStyle( fontSize: 15,
                    ),
                    cursorColor: Theme.of(context).textTheme.bodyText1!.color,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search News....',
                    ),
                  ),
                ),
              ),
            )
        ),

        //search button
        Container(
          decoration: const BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),

          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(
                Radius.circular(28.0),
              ),
              onTap: () {
                searchController.text.isEmpty ?

                Text(
                    "You just performed an empty search so we had nothing to show you.",
                  style: TextStyle( fontSize: 20, fontWeight: FontWeight.w500,color: Theme.of(context).textTheme.bodyText1!.color
                ),
                )
                    :  searchResultBloc = BlocProvider.of<SearchResultBloc>(context);
                searchResultBloc.add(FetchSearchResultEvent(searchQuery: searchController.text));
              },
              child: const Padding(
                padding:  EdgeInsets.all(10.0),
                child: Icon(Icons.search,
                    size: 25,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );

  }


}
