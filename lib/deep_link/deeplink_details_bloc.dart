// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:punch_ios_android/home_news/home_model.dart';
// import 'package:punch_ios_android/repository/news_repository.dart';
// import 'deep_link_details_event.dart';
// import 'deep_link_details_state.dart';
//
//
// class DeepLinkDetailsBloc extends Bloc<DeepLinkDetailsEvent,DeepLinkDetailsState>{
//   Repository repository;
//
//   DeepLinkDetailsBloc({required this.repository}) : super(DeepLinkDetailsInitialState());
//
//   @override
//   DeepLinkDetailsState get initialState => DeepLinkDetailsInitialState();
//
//   @override
//   Stream<DeepLinkDetailsState> mapEventToState(DeepLinkDetailsEvent event) async* {
//     if (event is FetchDeepLinkDetailsEvent) {
//       yield DeepLinkDetailsLoadingState();
//       try{
//         var response = await repository.fetchSingleNews(event.slug);
//         List<HomeNewsModel> model = response.homeNewss;
//         if(model.isNotEmpty){
//           yield DeepLinkDetailsLoadedState(model:model[0],message: "News Updated");
//         }else{
//           yield DeepLinkDetailsLoadFailureState(error:'This news is no longer available');
//
//         }
//
//         // yield DeepLinkDetailsLoadedState(DeepLinkDetails:DeepLinkDetails);
//       }catch(e){
//         yield DeepLinkDetailsLoadFailureState(error: 'Could not load link');
//       }
//     }
//
//
//   }
//
// }


import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'deep_link_details_event.dart';
import 'deep_link_details_state.dart';

class DeepLinkDetailsBloc extends Bloc<DeepLinkDetailsEvent,DeepLinkDetailsState>{
   Repository repository;

  DeepLinkDetailsBloc({required this.repository}) : super(DeepLinkDetailsInitialState());

  @override
  DeepLinkDetailsState get initialState => DeepLinkDetailsInitialState();

  @override
  Stream<DeepLinkDetailsState> mapEventToState(DeepLinkDetailsEvent event) async* {
    if (event is FetchDeepLinkDetailsEvent) {
      yield DeepLinkDetailsLoadingState();
      try{
        var response = await repository.fetchSingleNews(event.slug);
        List<HomeNewsModel> model = response.homeNewss;
        if(model.length>0){
          yield DeepLinkDetailsLoadedState(model:model[0],message: "News Updated");
        }else{
          yield DeepLinkDetailsLoadFailureState(error:'This news is no longer available');

        }

        // yield DeepLinkDetailsLoadedState(DeepLinkDetails:DeepLinkDetails);
      }catch(e){
        yield DeepLinkDetailsLoadFailureState(error: 'Could not load link');
      }
    }


  }

}