import 'package:equatable/equatable.dart';
import 'package:punch_ios_android/live_video/live_video_model.dart';

abstract class LiveVideoState extends Equatable {
  @override
  List<Object> get props => [];
}

class LiveVideoInitialState extends LiveVideoState {
  @override
  List<Object> get props => [];
}

class LiveVideoLoadingState extends LiveVideoState {
  @override
  List<Object> get props => [];
}


class LiveVideoRefreshingState extends LiveVideoState {
  @override
  List<Object> get props => [];
}

class LiveVideoLoadedState extends LiveVideoState {
  final List<LiveVideoModel> liveVideo;
  final String message;
  LiveVideoLoadedState({required this.liveVideo, required this.message});

  @override
  List<Object> get props => [];
}


class LiveVideoLoadFailureState extends LiveVideoState {
  final String error;

  LiveVideoLoadFailureState({required this.error});

  @override
  List<Object> get props => [error];
}
