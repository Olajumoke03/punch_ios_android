import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:punch_ios_android/live_video/live_video_event.dart';
import 'package:punch_ios_android/live_video/live_video_model.dart';
import 'package:punch_ios_android/live_video/live_video_state.dart';
import 'package:punch_ios_android/repository/news_repository.dart';


class LiveVideoBloc extends Bloc<LiveVideoEvent,LiveVideoState>{
  Repository repository;

  LiveVideoBloc({required this.repository}) : super(LiveVideoInitialState());

  LiveVideoState get initialState => LiveVideoInitialState();

  @override
  Stream<LiveVideoState> mapEventToState(LiveVideoEvent event) async* {

    if (event is FetchLiveVideosEvent) {
      yield LiveVideoLoadingState();
      try{
        List<LiveVideoModel>  liveVideoModel = await repository.fetchLiveVideo();
        if(liveVideoModel.length>0) {
          yield LiveVideoLoadedState(liveVideo: liveVideoModel, message: '');
          print("liveVideo loaded");

          print("live video length from bloc- " + liveVideoModel.length.toString());
        }
      }catch(e){
        yield LiveVideoLoadFailureState(error: 'Could not load link');
      }
    }
  }

}