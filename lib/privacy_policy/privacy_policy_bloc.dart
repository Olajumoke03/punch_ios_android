import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punch_ios_android/privacy_policy/privacy_model.dart';
import 'package:punch_ios_android/privacy_policy/privacy_policy_event.dart';
import 'package:punch_ios_android/privacy_policy/privacy_policy_state.dart';

import '../repository/news_repository.dart';


class PrivacyPolicyBloc extends Bloc<PrivacyPolicyEvent,PrivacyPolicyState>{
  Repository repository;

  PrivacyPolicyBloc({required this.repository}) : super(PrivacyPolicyInitialState());

  @override
  PrivacyPolicyState get initialState => PrivacyPolicyInitialState();

  @override
  Stream<PrivacyPolicyState> mapEventToState(PrivacyPolicyEvent event) async* {
    if (event is PrivacyPolicyEvent) {
      yield PrivacyPolicyLoadingState();
      try{
        PrivacyPolicyModel privacy = await repository.fetchPrivacyPolicy();
        yield PrivacyPolicyLoadedState(privacyPolicy:privacy, message: '');


      }catch(e){
        yield PrivacyPolicyLoadFailureState(error: e.toString());
      }
    }
  }
}