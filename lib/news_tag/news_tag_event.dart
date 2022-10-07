import 'package:equatable/equatable.dart';

abstract class NewsTagEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class FetchNewsTagEvent extends NewsTagEvent {
  final String id;
 FetchNewsTagEvent({required this.id});

   @override
  List<Object> get props => [];
}

class FetchMoreNewsTagEvent extends NewsTagEvent {
  final int page;
  final String id;
  FetchMoreNewsTagEvent({ required this.page, required this.id});

  @override
  List<Object> get props => [];
}

