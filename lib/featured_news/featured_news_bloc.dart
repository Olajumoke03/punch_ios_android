import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:punch_ios_android/featured_news/featured_news_event.dart';
import 'package:punch_ios_android/featured_news/featured_news_response.dart';
import 'package:punch_ios_android/featured_news/featured_news_state.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/utility/constants.dart';


class FeaturedNewsBloc extends Bloc<FeaturedNewsEvent,FeaturedNewsState>{
  final Repository repository;

  FeaturedNewsBloc({required this.repository}) : super(FeaturedNewsInitialState());

  @override
  FeaturedNewsState get initialState => FeaturedNewsInitialState();

  @override
  Stream<FeaturedNewsState> mapEventToState(FeaturedNewsEvent event) async* {
    if (event is FetchFeaturedNewsEvent) {
      // load news initially from cache
      String cachedJson =  await repository.getAnyStringValueFromCache(Constants.featuredNewsCacheKey);
      if(cachedJson!=null && cachedJson.isNotEmpty){
        FeaturedNewsResponse chachedNewsResponse = FeaturedNewsResponse.fromJson(jsonDecode(cachedJson));
        List<HomeNewsModel> cachedNews = chachedNewsResponse.featuredNewss;
        yield FeaturedCachedNewsLoadedState(featuredNews:cachedNews,message: "");
        // we want to check if there's any thing cached
        // if nothing is cached, then yield loading state
        if(cachedNews.length<=0){
          yield FeaturedNewsLoadingState();
        }

      }

      try{
        List<HomeNewsModel> featuredNews = await repository.fetchFeaturedNews();
        yield FeaturedNewsLoadedState(featuredNews:featuredNews, message: "Featured News Updated");
      }catch(e){
        yield FeaturedNewsLoadFailureState(error: e.toString());
      }
    }
    if (event is RefreshFeaturedNewsEvent) {
      yield FeaturedNewsRefreshingState();
      try{
        List<HomeNewsModel> featuredNews = await repository.fetchFeaturedNews();
        yield FeaturedNewsLoadedState(featuredNews:featuredNews, message:  "Featured News Updated");
      }catch(e){
        yield FeaturedNewsLoadFailureState(error: e.toString());
      }
    }


    if (event is FetchMoreFeaturedNewsEvent) {
      yield FeaturedNewsLoadingMoreState();
      try{
        List<HomeNewsModel> featuredNews = await repository.fetchFeaturedNews();
        yield FeaturedNewsLoadedState(featuredNews:featuredNews, message: "Featured News Updated");

      }catch(e){
        yield FeaturedNewsLoadFailureState(error: e.toString());

      }
    }
  }

}