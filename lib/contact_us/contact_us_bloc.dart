// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:punch_ios_android/contact_us/contact_us_model.dart';
// import 'package:punch_ios_android/repository/news_repository.dart';
// import 'contact_us_event.dart';
// import 'contact_us_state.dart';
//
// class ContactBloc extends Bloc<ContactEvent,ContactState>{
//   Repository? repository;
//
//   ContactBloc({ this.repository}): super(ContactInitialState());
//
// ContactState get initialState => ContactInitialState();
//
// @override
// Stream<ContactState> mapEventToState(ContactEvent event) async* {
//   if (event is FetchContactEvent) {
//     yield ContactLoadingState();
//     try{
//       ContactModel Contact = await repository!.fetchContact();
//       yield ContactLoadedState(Contact:Contact);
//     }catch(e){
//       yield ContactLoadFailureState(error: e.toString());
//     }
//   }
//
// }
//
// }