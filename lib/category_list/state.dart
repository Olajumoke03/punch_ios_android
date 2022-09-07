import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:punch_ios_android/category_list/model.dart';
import 'package:punch_ios_android/home_news/home_model.dart';

abstract class CategoryListState extends Equatable {
  @override
  List<Object> get props => [];
}

class CategoryListInitialState extends CategoryListState {
  @override
  List<Object> get props => [];
}

class CategoryListLoadingState extends CategoryListState {
  @override
  List<Object> get props => [];
}


class CategoryListLoadingMoreState extends CategoryListState {
  @override
  List<Object> get props => [];
}


class CategoryListRefreshingState extends CategoryListState {
  @override
  List<Object> get props => [];
}

class CategoryListLoadedState extends CategoryListState {
  List<CategoryListModel> categoryList;
  String message;
  CategoryListLoadedState({required this.categoryList, required this.message});

  @override
  List<Object> get props => [];
}



class CategoryListRefreshedState extends CategoryListState {
  List<CategoryListModel> categoryList;
  String message;
  CategoryListRefreshedState({required this.categoryList, required this.message});

  @override
  List<Object> get props => [];
}

class CategoryListMoreLoadedState extends CategoryListState {
  List<CategoryListModel> CategoryList;
  CategoryListMoreLoadedState({required this.CategoryList});

  @override
  List<Object> get props => [];
}

class CategoryListMoreFailureState extends CategoryListState {
  final String error;

  CategoryListMoreFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class CategoryListLoadFailureState extends CategoryListState {
  final String error;

  CategoryListLoadFailureState({required this.error});

  @override
  List<Object> get props => [error];
}
