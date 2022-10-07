import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'package:punch_ios_android/utility/constants.dart';
import 'home_event.dart';
import 'home_response.dart';
import 'home_state.dart';


class HomeNewsBloc extends Bloc<HomeNewsEvent, HomeNewsState>{
 final Repository repository;

  HomeNewsBloc( {required this.repository}) : super(InitialState());

  HomeNewsState get initialState => InitialState();

  @override

  Stream<HomeNewsState> mapEventToState(HomeNewsEvent event) async* {
    if (event is FetchHomeNewsEvent) {
      try{
        // load news initially from cache
        String cachedJson =  await repository.getAnyStringValueFromCache(Constants.featuredNewsCacheKey);
        // print("home cachedJson  : "+ cachedJson);

        if(cachedJson.isNotEmpty){
          HomeNewsResponse cachedNewsResponse = HomeNewsResponse.fromJson(jsonDecode(cachedJson));
          List<HomeNewsModel> cachedNews = cachedNewsResponse.homeNewss;
          yield HomeCachedNewsLoadedState(cachedNews:cachedNews,message: "");
          // we want to check if there's any thing cached, if nothing is cached, then yield loading state
          if(cachedNews.isEmpty){
            yield HomeNewsLoadingState();
            print("cachedIsEmpty  : "+ cachedJson);
          }
        }
        // then try to fetch from rest
        List<HomeNewsModel>  homeNews = await repository.fetchHomeNews();
        if(homeNews.isNotEmpty){
          yield HomeNewsLoadedState(homeNews:homeNews,message: "News Updated");
        }

      }catch(e){
        yield HomeNewsLoadFailureState(error: e.toString());
      }
    }
    if (event is RefreshHomeNewsEvent) {
      yield HomeNewsRefreshingState();
      try{
        List<HomeNewsModel> homeNews = await repository.fetchHomeNews();
        yield HomeNewsRefreshedState(homeNews:homeNews,message: "News Updated");
      }catch(e){
        yield HomeNewsLoadFailureState(error: e.toString());
      }
    }


    if (event is FetchMoreHomeNewsEvent) {
      yield  HomeNewsLoadingMoreState();
      try{
        List<HomeNewsModel> homeNews = await repository.fetchMoreHomeNews(event.page);
        yield HomeNewsMoreLoadedState(homeNews:homeNews);

      }catch(e){
        yield HomeNewsMoreFailureState(error: e.toString());


      }
    }
  }


}