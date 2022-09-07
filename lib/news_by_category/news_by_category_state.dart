import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:punch_ios_android/home_news/home_model.dart';

abstract class NewsByCategoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class NewsByCategoryInitialState extends NewsByCategoryState {
  @override
  List<Object> get props => [];
}

class NewsByCategoryLoadingState extends NewsByCategoryState {
  @override
  List<Object> get props => [];
}


class NewsByCategoryLoadingMoreState extends NewsByCategoryState {
  @override
  List<Object> get props => [];
}


class NewsByCategoryRefreshingState extends NewsByCategoryState {
  @override
  List<Object> get props => [];
}

class NewsByCategoryLoadedState extends NewsByCategoryState {
  List<HomeNewsModel> newsByCategory;
  String message;
  NewsByCategoryLoadedState({required this.newsByCategory, required this.message});

  @override
  List<Object> get props => [];
}

class NewsByCategoryCachedNewsLoadedState extends NewsByCategoryState {
  List<HomeNewsModel> cachedNews;
  String message;
  NewsByCategoryCachedNewsLoadedState({required this.cachedNews, required this.message});

  @override
  List<Object> get props => [];
}

class NewsByCategoryRefreshedState extends NewsByCategoryState {
  List<HomeNewsModel> newsByCategory;
  String message;
  NewsByCategoryRefreshedState({required this.newsByCategory, required this.message});

  @override
  List<Object> get props => [];
}

class NewsByCategoryMoreLoadedState extends NewsByCategoryState {
  List<HomeNewsModel> newsByCategory;
  NewsByCategoryMoreLoadedState({required this.newsByCategory});

  @override
  List<Object> get props => [];
}

class NewsByCategoryMoreFailureState extends NewsByCategoryState {
  final String error;

  NewsByCategoryMoreFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class NewsByCategoryLoadFailureState extends NewsByCategoryState {
  final String error;

  NewsByCategoryLoadFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class NewsByCategoryEmptyState extends NewsByCategoryState {
  String message;

  NewsByCategoryEmptyState({required this.message});
  @override
  List<Object> get props => [this.message];
}