import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'contact_us_model.dart';

abstract class ContactState extends Equatable {
  @override
  List<Object> get props => [];
}

class ContactInitialState extends ContactState {
  @override
  List<Object> get props => [];
}

class ContactLoadingState extends ContactState {
  @override
  List<Object> get props => [];
}

class ContactLoadedState extends ContactState {
 final  ContactModel? Contact;
  ContactLoadedState({@required this.Contact});

  @override
  List<Object> get props => [];
}

class ContactLoadFailureState extends ContactState {
  final String? error;

  ContactLoadFailureState({@required this.error});

  @override
  List<Object> get props => [error!];
}
