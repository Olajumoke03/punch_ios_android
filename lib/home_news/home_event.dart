import 'package:equatable/equatable.dart';

abstract class HomeNewsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchHomeNewsEvent extends HomeNewsEvent {
  @override
  List<Object> get props => [];
}


class RefreshHomeNewsEvent extends HomeNewsEvent {
  @override
  List<Object> get props => [];
}

class FetchCachedHomeNewsEvent extends HomeNewsEvent {
  @override
  List<Object> get props => [];
}

class FetchMoreHomeNewsEvent extends HomeNewsEvent {
  final int page;
  FetchMoreHomeNewsEvent({ required this.page});

  @override
  List<Object> get props => [];
}

class FetchFeaturedEvent extends HomeNewsEvent {
  @override
  List<Object> get props => [];
}


class FetchCachedFeaturedEvent extends HomeNewsEvent {
  @override
  List<Object> get props => [];
}

