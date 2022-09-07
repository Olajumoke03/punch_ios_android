// import 'package:punch_ios_android/search_result/search_model.dart';
//
// class SearchResultResponse {
//   List<SearchResultModel> searchResults;
//
//   SearchResultResponse({
//     // this.page,
//     this.searchResults
//   });
//
//   SearchResultResponse.fromJson(List<dynamic> json) {
//     //page = json['page'];
//     if (json != null) {
//      searchResults = new List<SearchResultModel>();
//       json.forEach((v) {
//         searchResults.add(new SearchResultModel.fromJson(v));
//       });
//     }
//   }
//
// }




import 'package:punch_ios_android/search_result/search_model.dart';

class SearchResultResponse {
  late List<SearchResultModel> searchResults;

  SearchResultResponse({ required this.searchResults});

  SearchResultResponse.fromJson(List<dynamic> json) {
    searchResults =  <SearchResultModel>[];
    json.forEach((v) {
      searchResults.add(SearchResultModel.fromJson(v));
    });
  }

  String toJson() {
    String data;
    data = searchResults.map((v) => v.toJson()).toList().toString();
    return data;
  }
}