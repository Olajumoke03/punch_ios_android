import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_event.dart';
import 'package:punch_ios_android/news_by_category/news_by_category_state.dart';
import 'package:punch_ios_android/repository/news_repository.dart';

class NewsByCategoryBloc extends Bloc<NewsByCategoryEvent,NewsByCategoryState>{
  final Repository repository;

  NewsByCategoryBloc({required this.repository}) : super(NewsByCategoryInitialState());

@override
NewsByCategoryState get initialState => NewsByCategoryInitialState();

@override
Stream<NewsByCategoryState> mapEventToState(NewsByCategoryEvent event) async* {
  if (event is FetchNewsByCategoryEvent) {
    yield NewsByCategoryLoadingState();
    try{
        List<HomeNewsModel> newsByCategory = await repository.fetchNewsByCategory(event.id!);
        if(newsByCategory.isNotEmpty){
          yield NewsByCategoryLoadedState(newsByCategory:newsByCategory,message: "News Updated");
        }
        else{
          yield NewsByCategoryEmptyState(message: "There is no news in this category yet.");
        }
    }catch(e){
      yield NewsByCategoryLoadFailureState(error: e.toString());
    }
  }

  if (event is RefreshNewsByCategoryEvent) {
    yield NewsByCategoryRefreshingState();
    try{
      List<HomeNewsModel> newsByCategory = await repository.fetchNewsByCategory(event.id!);
      yield NewsByCategoryRefreshedState(newsByCategory:newsByCategory,message: "News Updated");
    }catch(e){
      yield NewsByCategoryLoadFailureState(error: e.toString());
    }
  }

  if (event is FetchMoreNewsByCategoryEvent) {
    yield  NewsByCategoryLoadingMoreState();
    try{
      List<HomeNewsModel> newsByCategory = await repository.fetchMoreNewsByCategory(event.page, event.id!);
      yield NewsByCategoryMoreLoadedState(newsByCategory:newsByCategory);

    }catch(e){
      yield NewsByCategoryMoreFailureState(error: e.toString());


    }
  }

}

}