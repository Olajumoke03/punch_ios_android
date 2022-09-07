import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'news_tag_event.dart';
import 'news_tag_state.dart';

class NewsTagBloc extends Bloc<NewsTagEvent,NewsTagState>{
  Repository repository;

  NewsTagBloc({required this.repository}) : super(NewsTagInitialState());

@override
NewsTagState get initialState => NewsTagInitialState();

@override
Stream<NewsTagState> mapEventToState(NewsTagEvent event) async* {
  if (event is FetchNewsTagEvent) {
    yield NewsTagLoadingState();
    try{
        List<HomeNewsModel> newsTag = await repository.fetchNewsTag(event.id);
        if(newsTag.length>0){
          yield NewsTagLoadedState(newsTag:newsTag,message: "News Tag Updated");
          print("NewsTagLoadedState");
        }

        // yield NewsByCategoryLoadedState(newsByCategory:newsByCategory);
    }catch(e){
      yield NewsTagLoadFailureState(error: e.toString());
    }
  }

  // if (event is FetchMoreNewsTagEvent) {
  //   yield  NewsTagLoadingMoreState();
  //   try{
  //     List<NewsTagModel> newsTag = await newsTagRepository.fetchMoreNewsByCategory(event.page, event.id);
  //     yield NewsByCategoryMoreLoadedState(newsByCategory:newsByCategory);
  //
  //   }catch(e){
  //     yield NewsByCategoryMoreFailureState(error: e.toString());
  //
  //   }
  // }

}

}
