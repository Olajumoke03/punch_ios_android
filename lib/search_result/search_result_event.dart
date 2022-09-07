import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class SearchResultEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSearchResultEvent extends SearchResultEvent {
  String searchQuery;

  FetchSearchResultEvent ({required this.searchQuery});
   @override
  List<Object> get props => [];
}


class RefreshSearchResultEvent extends SearchResultEvent {
  @override
  List<Object> get props => [];
}

class FetchCachedSearchResultEvent extends SearchResultEvent {
  @override
  List<Object> get props => [];
}

class FetchMoreSearchResultEvent extends SearchResultEvent {
  final int page;
  FetchMoreSearchResultEvent({ required this.page});

  @override
  List<Object> get props => [];
}

