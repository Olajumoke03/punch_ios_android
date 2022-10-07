import 'model.dart';

class CategoryListResponse {
  late List<CategoryListModel> categoryLists;

  CategoryListResponse({ required this.categoryLists});

  CategoryListResponse.fromJson(List<dynamic> json) {
    categoryLists =  <CategoryListModel>[];
    for (var v in json) {
      categoryLists.add(CategoryListModel.fromJson(v));
    }
    // print("category json something " + json.toString());

  }

  String toJson() {
    String data;
    data = categoryLists.map((v) => v.toJson()).toList().toString();
    return data;
  }
}