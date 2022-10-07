import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:punch_ios_android/category_list/model.dart';
import 'package:punch_ios_android/repository/news_repository.dart';
import 'event.dart';
import 'state.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState>{
 final Repository repository;

  CategoryListBloc( {required this.repository}) : super(CategoryListInitialState());

  CategoryListState get initialState => CategoryListInitialState();

  @override

  Stream<CategoryListState> mapEventToState(CategoryListEvent event) async* {
    if (event is FetchCategoryListEvent) {
      try{
        List<CategoryListModel>  categoryList = await repository.fetchCategoryList();
        if(categoryList.isNotEmpty){
          yield CategoryListLoadedState(categoryList:categoryList,message: "Category List Updated");
        }

      }catch(e){
        yield CategoryListLoadFailureState(error: e.toString());
      }
    }
    if (event is RefreshCategoryListEvent) {
      yield CategoryListRefreshingState();
      try{
        List<CategoryListModel> categoryList = await repository.fetchCategoryList();
        yield CategoryListRefreshedState(categoryList:categoryList,message: "Category List Updated");
      }catch(e){
        yield CategoryListLoadFailureState(error: e.toString());
      }
    }


  }


}