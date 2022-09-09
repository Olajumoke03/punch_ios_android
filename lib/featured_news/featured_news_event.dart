import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class FeaturedNewsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchFeaturedNewsEvent extends FeaturedNewsEvent {
  @override
  List<Object> get props => [];
}


class RefreshFeaturedNewsEvent extends FeaturedNewsEvent {
  @override
  List<Object> get props => [];
}

class FetchCachedFeaturedNewsEvent extends FeaturedNewsEvent {
  @override
  List<Object> get props => [];
}

class FetchMoreFeaturedNewsEvent extends FeaturedNewsEvent {
  final int? page;
  FetchMoreFeaturedNewsEvent({  this.page});

  @override
  List<Object> get props => [];
}

