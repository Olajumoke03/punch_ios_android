import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:punch_ios_android/about_us/about_model.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'about_us_event.dart';
import 'about_us_state.dart';

class AboutUsBloc extends Bloc<AboutUsEvent,AboutUsState>{
  Repository? repository;

  AboutUsBloc({ this.repository}): super(AboutUsInitialState());

AboutUsState get initialState => AboutUsInitialState();

@override
Stream<AboutUsState> mapEventToState(AboutUsEvent event) async* {
  if (event is FetchAboutUsEvent) {
    yield AboutUsLoadingState();
    try{
      AboutUsModel aboutUs = await repository!.fetchAboutUs();
      yield AboutUsLoadedState(aboutUs:aboutUs);
    }catch(e){
      yield AboutUsLoadFailureState(error: e.toString());
    }
  }

}

}