// import 'dart:async';
// import 'dart:convert';
// import 'package:bloc/bloc.dart';
// import 'package:punch_ios_android/featured_news/featured_news_event.dart';
// import 'package:punch_ios_android/featured_news/featured_news_response.dart';
// import 'package:punch_ios_android/featured_news/featured_news_state.dart';
// import 'package:punch_ios_android/home_news/home_model.dart';
// import 'package:punch_ios_android/repository/news_repository.dart';
// import 'package:punch_ios_android/utility/constants.dart';
//
//
// class FeaturedNewsBloc extends Bloc<FeaturedNewsEvent,FeaturedNewsState>{
//   final Repository repository;
//
//   FeaturedNewsBloc({required this.repository}) : super(FeaturedNewsInitialState());
//
//   FeaturedNewsState get initialState => FeaturedNewsInitialState();
//
//   @override
//   Stream<FeaturedNewsState> mapEventToState(FeaturedNewsEvent event) async* {
//     if (event is FetchFeaturedNewsEvent) {
//       // load news initially from cache
//       String cachedJson =  await repository.getAnyStringValueFromCache(Constants.featuredNewsCacheKey);
//       if(cachedJson.isNotEmpty){
//         FeaturedNewsResponse chachedNewsResponse = FeaturedNewsResponse.fromJson(jsonDecode(cachedJson));
//         List<HomeNewsModel> cachedNews = chachedNewsResponse.featuredNewss;
//         yield FeaturedCachedNewsLoadedState(featuredNews:cachedNews,message: "");
//         // we want to check if there's any thing cached
//         // if nothing is cached, then yield loading state
//         if(cachedNews.isEmpty){
//           yield FeaturedNewsLoadingState();
//         }
//
//       }
//
//       try{
//         List<HomeNewsModel> featuredNews = await repository.fetchFeaturedNews();
//         yield FeaturedNewsLoadedState(featuredNews:featuredNews, message: "Featured News Updated");
//       }catch(e){
//         yield FeaturedNewsLoadFailureState(error: e.toString());
//       }
//     }
//     if (event is RefreshFeaturedNewsEvent) {
//       yield FeaturedNewsRefreshingState();
//       try{
//         List<HomeNewsModel> featuredNews = await repository.fetchFeaturedNews();
//         yield FeaturedNewsLoadedState(featuredNews:featuredNews, message:  "Featured News Updated");
//       }catch(e){
//         yield FeaturedNewsLoadFailureState(error: e.toString());
//       }
//     }
//
//
//     if (event is FetchMoreFeaturedNewsEvent) {
//       yield FeaturedNewsLoadingMoreState();
//       try{
//         List<HomeNewsModel> featuredNews = await repository.fetchFeaturedNews();
//         yield FeaturedNewsLoadedState(featuredNews:featuredNews, message: "Featured News Updated");
//
//       }catch(e){
//         yield FeaturedNewsLoadFailureState(error: e.toString());
//
//       }
//     }
//   }
//
// }

import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/utility/constants.dart';
import 'featured_news_event.dart';
import 'featured_news_response.dart';
import 'featured_news_state.dart';



class FeaturedNewsBloc extends Bloc<FeaturedNewsEvent, FeaturedNewsState>{
  final Repository repository;

  FeaturedNewsBloc({required this.repository}) : super(FeaturedNewsInitialState());
  FeaturedNewsState get initialState => FeaturedNewsInitialState();

  @override

  Stream<FeaturedNewsState> mapEventToState(FeaturedNewsEvent event) async* {
    if (event is FetchFeaturedNewsEvent) {
      try{
        // load news initially from cache
        String cachedJson =  await repository.getAnyStringValueFromCache(Constants.featuredNewsCacheKey);
        // print("home cachedJson  : "+ cachedJson);

        if(cachedJson.isNotEmpty){
          FeaturedNewsResponse cachedNewsResponse = FeaturedNewsResponse.fromJson(jsonDecode(cachedJson));
          List<HomeNewsModel> cachedNews = cachedNewsResponse.featuredNewss;
          yield FeaturedCachedNewsLoadedState(featuredNews:cachedNews,message: "");
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
        yield FeaturedNewsLoadedState(featuredNews:featuredNews,message: "News Updated");
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
