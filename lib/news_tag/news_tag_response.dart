// import '../news_model.dart';
//
// class NewsTagResponse {
//   List<NewsModel> newsTags;
//
//   NewsTagResponse({
//     this.newsTags
//   });
//
//   NewsTagResponse.fromJson(List<dynamic> json) {
//     //page = json['page'];
//     if (json != null) {
//       newsTags = new List<NewsModel>();
//       json.forEach((v) {
//         newsTags.add(new NewsModel.fromJson(v));
//       });
//     }
//   }
//
// }

import 'package:punch_ios_android/home_news/home_model.dart';


class NewsTagResponse {
  late List<HomeNewsModel> newsTags;

  NewsTagResponse({ required this.newsTags});

  NewsTagResponse.fromJson(List<dynamic> json) {
    newsTags =  <HomeNewsModel>[];
    json.forEach((v) {
      newsTags.add(HomeNewsModel.fromJson(v));
    });
  }

  String toJson() {
    String data;
    data = newsTags.map((v) => v.toJson()).toList().toString();
    return data;
  }
}