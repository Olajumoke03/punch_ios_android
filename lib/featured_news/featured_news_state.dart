import 'package:equatable/equatable.dart';
import 'package:punch_ios_android/featured_news/featured_news_model.dart';
import 'package:punch_ios_android/home_news/home_model.dart';

abstract class FeaturedNewsState extends Equatable {
  @override
  List<Object> get props => [];
}

class FeaturedNewsInitialState extends FeaturedNewsState {
  @override
  List<Object> get props => [];
}

class FeaturedNewsLoadingState extends FeaturedNewsState {
  @override
  List<Object> get props => [];
}


class FeaturedNewsLoadingMoreState extends FeaturedNewsState {
  @override
  List<Object> get props => [];
}


class FeaturedNewsRefreshingState extends FeaturedNewsState {
  @override
  List<Object> get props => [];
}

class FeaturedNewsLoadedState extends FeaturedNewsState {
  final List<HomeNewsModel> featuredNews;
  final String message;
  FeaturedNewsLoadedState({required this.featuredNews, required this.message});

  @override
  List<Object> get props => [];
}

class FeaturedCachedNewsLoadedState extends FeaturedNewsState {
  final List<HomeNewsModel> featuredCachedNews;
  final String message;
  FeaturedCachedNewsLoadedState({required this.featuredCachedNews, required this.message});

  @override
  List<Object> get props => [];
}

class FeaturedNewsMoreLoadedState extends FeaturedNewsState {
  final List<FeaturedNewsModel> featuredNews;
  FeaturedNewsMoreLoadedState({required this.featuredNews});

  @override
  List<Object> get props => [];
}

class FeaturedNewsMoreFailureState extends FeaturedNewsState {
  final String error;

  FeaturedNewsMoreFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class FeaturedNewsLoadFailureState extends FeaturedNewsState {
  final String error;

  FeaturedNewsLoadFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class FeaturedNewsRefreshedState extends FeaturedNewsState {
  final List<HomeNewsModel> featuredNews;
  final String message;
  FeaturedNewsRefreshedState({required this.featuredNews, required this.message});

  @override
  List<Object> get props => [];
}