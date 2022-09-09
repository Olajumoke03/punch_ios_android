

import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:punch_ios_android/featured_news/featured_news_event.dart';
import 'package:punch_ios_android/featured_news/featured_news_response.dart';
import 'package:punch_ios_android/featured_news/featured_news_state.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/utility/constants.dart';



class FeaturedNewsBloc extends Bloc<FeaturedNewsEvent, FeaturedNewsState>{
  final Repository repository;

  FeaturedNewsBloc( {required this.repository}) : super(FeaturedNewsInitialState());

  FeaturedNewsState get initialState => FeaturedNewsInitialState();

  @override
  Stream<FeaturedNewsState> mapEventToState(FeaturedNewsEvent event) async* {
    if (event is FetchFeaturedNewsEvent) {
      try{
        // // load news initially from cache
        String cachedJson =  await repository.getAnyStringValueFromCache(Constants.featuredNewsCacheKey);
        print("featured cachedJson  : "+ cachedJson);

        if(cachedJson.isNotEmpty){
          FeaturedNewsResponse cachedNewsResponse = FeaturedNewsResponse.fromJson(jsonDecode(cachedJson));
          List<HomeNewsModel> cachedNews = cachedNewsResponse.featuredNewss;
          yield FeaturedCachedNewsLoadedState(cachedNews:cachedNews,message: "");
          // we want to check if there's any thing cached, if nothing is cached, then yield loading state
          if(cachedNews.isEmpty){
            yield FeaturedNewsLoadingState();
            print("cachedIsEmpty  : "+ cachedJson);

          }
        }
        // then try to fetch from rest
        List<HomeNewsModel>  featuredNews = await repository.fetchFeaturedNews();
        if(featuredNews.isNotEmpty){
          yield FeaturedNewsLoadedState(featuredNews:featuredNews,message: "News Updated");
        }

      }catch(e){
        yield FeaturedNewsLoadFailureState(error: e.toString());
      }
    }
    if (event is RefreshFeaturedNewsEvent) {
      yield FeaturedNewsRefreshingState();
      try{
        List<HomeNewsModel> featuredNews = await repository.fetchFeaturedNews();
        yield FeaturedNewsRefreshedState(featuredNews:featuredNews,message: "News Updated");
      }catch(e){
        yield FeaturedNewsLoadFailureState(error: e.toString());
      }
    }


    // if (event is FetchMoreFeaturedNewsEvent) {
    //   yield  FeaturedNewsLoadingMoreState();
    //   try{
    //     List<HomeNewsModel> featuredNews = await repository.fetchMoreFeaturedNews(event.page);
    //     yield FeaturedNewsMoreLoadedState(featuredNews:featuredNews);
    //
    //   }catch(e){
    //     yield FeaturedNewsMoreFailureState(error: e.toString());
    //   }
    // }

  }

}