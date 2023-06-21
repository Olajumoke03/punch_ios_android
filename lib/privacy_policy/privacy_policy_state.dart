import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:punch_ios_android/privacy_policy/privacy_model.dart';

abstract class PrivacyPolicyState extends Equatable {
  @override
  List<Object> get props => [];
}

class PrivacyPolicyInitialState extends PrivacyPolicyState {
  @override
  List<Object> get props => [];
}

class PrivacyPolicyLoadingState extends PrivacyPolicyState {
  @override
  List<Object> get props => [];
}

class PrivacyPolicyLoadedState extends PrivacyPolicyState {
  late PrivacyPolicyModel privacyPolicy;
  late String message;
  PrivacyPolicyLoadedState({required this.privacyPolicy, required this.message});

  @override
  List<Object> get props => [];
}


class PrivacyPolicyLoadFailureState extends PrivacyPolicyState {
  final String error;

  PrivacyPolicyLoadFailureState({required this.error});

  @override
  List<Object> get props => [error];
}
