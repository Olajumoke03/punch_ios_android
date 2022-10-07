import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/search_result/search_model.dart';
import 'package:punch_ios_android/search_result/search_result_event.dart';
import 'package:punch_ios_android/search_result/search_result_state.dart';


class SearchResultBloc extends Bloc<SearchResultEvent,SearchResultState>{
  // Repository repository;
  //
  // const SearchResultBloc({required this.searchResultRepository}) : super(SearchResultInitialState());

  final Repository repository;

  SearchResultBloc( {required this.repository}) : super(SearchResultInitialState());

SearchResultState get initialState => SearchResultInitialState();

@override
Stream<SearchResultState> mapEventToState(SearchResultEvent event) async* {
  if (event is FetchSearchResultEvent) {
    yield SearchResultLoadingState();
    try{
      List<SearchResultModel> searchResult = await repository.searchNews(event.searchQuery);
      if(searchResult.isNotEmpty){
        yield SearchResultLoadedState(searchResult:searchResult,message: "SearchResult Updated");
      } else{
        yield SearchResultEmptyState(message: "No Result Found!");
      }

    }catch(e){
      yield SearchResultLoadFailureState(error: e.toString());
    }
  }

}

}