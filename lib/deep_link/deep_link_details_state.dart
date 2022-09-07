import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:punch_ios_android/home_news/home_model.dart';

abstract class DeepLinkDetailsState extends Equatable {
  @override
  List<Object> get props => [];
}

class DeepLinkDetailsInitialState extends DeepLinkDetailsState {
  @override
  List<Object> get props => [];
}

class DeepLinkDetailsLoadingState extends DeepLinkDetailsState {
  @override
  List<Object> get props => [];
}


class DeepLinkDetailsLoadingMoreState extends DeepLinkDetailsState {
  @override
  List<Object> get props => [];
}


class DeepLinkDetailsRefreshingState extends DeepLinkDetailsState {
  @override
  List<Object> get props => [];
}

class DeepLinkDetailsLoadedState extends DeepLinkDetailsState {
  HomeNewsModel model;
  String message;
  DeepLinkDetailsLoadedState({required this.model, required this.message});

  @override
  List<Object> get props => [];
}

class DeepLinkDetailsCachedNewsLoadedState extends DeepLinkDetailsState {
  List<HomeNewsModel> cachedNews;
  String message;
  DeepLinkDetailsCachedNewsLoadedState({required this.cachedNews, required this.message});

  @override
  List<Object> get props => [];
}




class DeepLinkDetailsLoadFailureState extends DeepLinkDetailsState {
  final String error;

  DeepLinkDetailsLoadFailureState({required this.error});

  @override
  List<Object> get props => [error];
}
