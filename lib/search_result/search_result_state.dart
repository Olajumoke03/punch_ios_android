import 'package:equatable/equatable.dart';
import 'package:punch_ios_android/search_result/search_model.dart';

abstract class SearchResultState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchResultInitialState extends SearchResultState {
  @override
  List<Object> get props => [];
}

class SearchResultLoadingState extends SearchResultState {
  @override
  List<Object> get props => [];
}


class SearchResultLoadingMoreState extends SearchResultState {
  @override
  List<Object> get props => [];
}


class SearchResultRefreshingState extends SearchResultState {
  @override
  List<Object> get props => [];
}

class SearchResultLoadedState extends SearchResultState {
 final List<SearchResultModel> searchResult;
 final String? message;
  SearchResultLoadedState({required this.searchResult, this.message});

  @override
  List<Object> get props => [];
}

class SearchResultMoreLoadedState extends SearchResultState {
  final List<SearchResultModel> searchResult;
  SearchResultMoreLoadedState({required this.searchResult});

  @override
  List<Object> get props => [];
}

class SearchResultMoreFailureState extends SearchResultState {
  final String error;

  SearchResultMoreFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class SearchResultLoadFailureState extends SearchResultState {
  final String error;

  SearchResultLoadFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class SearchResultEmptyState extends SearchResultState{
  final String message;
  SearchResultEmptyState({required this.message});

  @override
  List<Object> get props => [];
}