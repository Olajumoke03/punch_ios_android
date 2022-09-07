import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DeepLinkDetailsEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class FetchDeepLinkDetailsEvent extends DeepLinkDetailsEvent {

  String slug;
  FetchDeepLinkDetailsEvent({required this.slug});

   @override
  List<Object> get props => [];
}

class FetchMoreDeepLinkDetailsEvent extends DeepLinkDetailsEvent {
  final int page;
  final String id;
  FetchMoreDeepLinkDetailsEvent({ required this.page, required this.id});

  @override
  List<Object> get props => [];
}

