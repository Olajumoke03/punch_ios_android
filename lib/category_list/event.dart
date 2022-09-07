import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchCategoryListEvent extends CategoryListEvent {
  @override
  List<Object> get props => [];
}


class RefreshCategoryListEvent extends CategoryListEvent {
  @override
  List<Object> get props => [];
}

class FetchCachedCategoryListEvent extends CategoryListEvent {
  @override
  List<Object> get props => [];
}

class FetchMoreCategoryListEvent extends CategoryListEvent {
  final int page;
  FetchMoreCategoryListEvent({ required this.page});

  @override
  List<Object> get props => [];
}

