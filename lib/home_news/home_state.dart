import 'package:equatable/equatable.dart';
import 'package:punch_ios_android/home_news/home_model.dart';

abstract class HomeNewsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends HomeNewsState {
  @override
  List<Object> get props => [];
}

class HomeNewsLoadingState extends HomeNewsState {
  @override
  List<Object> get props => [];
}


class HomeNewsLoadingMoreState extends HomeNewsState {
  @override
  List<Object> get props => [];
}


class HomeNewsRefreshingState extends HomeNewsState {
  @override
  List<Object> get props => [];
}

class HomeNewsLoadedState extends HomeNewsState {
  final List<HomeNewsModel> homeNews;
  final String message;
  HomeNewsLoadedState({required this.homeNews, required this.message});

  @override
  List<Object> get props => [];
}

class HomeCachedNewsLoadedState extends HomeNewsState {
  final List<HomeNewsModel> cachedNews;
  final String message;
  HomeCachedNewsLoadedState({required this.cachedNews, required this.message});

  @override
  List<Object> get props => [];
}

class HomeNewsRefreshedState extends HomeNewsState {
  final List<HomeNewsModel> homeNews;
  final String message;
  HomeNewsRefreshedState({required this.homeNews, required this.message});

  @override
  List<Object> get props => [];
}

class HomeNewsMoreLoadedState extends HomeNewsState {
  final List<HomeNewsModel> homeNews;
  HomeNewsMoreLoadedState({required this.homeNews});

  @override
  List<Object> get props => [];
}

class HomeNewsMoreFailureState extends HomeNewsState {
  final String error;

  HomeNewsMoreFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class HomeNewsLoadFailureState extends HomeNewsState {
  final String error;

  HomeNewsLoadFailureState({required this.error});

  @override
  List<Object> get props => [error];
}
