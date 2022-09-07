import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class NewsByCategoryEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class FetchNewsByCategoryEvent extends NewsByCategoryEvent {

  String? id;
  FetchNewsByCategoryEvent({required this.id});

   @override
  List<Object> get props => [];
}

class FetchMoreNewsByCategoryEvent extends NewsByCategoryEvent {
  final int page;
  final String? id;
  FetchMoreNewsByCategoryEvent({ required this.page, required this.id});

  @override
  List<Object> get props => [];
}


class RefreshNewsByCategoryEvent extends NewsByCategoryEvent {
  final String? id;
  RefreshNewsByCategoryEvent({required this.id});

  @override
  List<Object> get props => [];
}
