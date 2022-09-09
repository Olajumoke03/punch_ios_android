import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'about_model.dart';

abstract class AboutUsState extends Equatable {
  @override
  List<Object> get props => [];
}

class AboutUsInitialState extends AboutUsState {
  @override
  List<Object> get props => [];
}

class AboutUsLoadingState extends AboutUsState {
  @override
  List<Object> get props => [];
}

class AboutUsLoadedState extends AboutUsState {
 final  AboutUsModel? aboutUs;
  AboutUsLoadedState({@required this.aboutUs});

  @override
  List<Object> get props => [];
}

class AboutUsLoadFailureState extends AboutUsState {
  final String? error;

  AboutUsLoadFailureState({@required this.error});

  @override
  List<Object> get props => [error!];
}
