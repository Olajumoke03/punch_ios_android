

import 'package:punch_ios_android/home_news/home_model.dart';

class FeaturedNewsResponse {
  late List<HomeNewsModel> featuredNewss;

  FeaturedNewsResponse({required featuredNewss});

  FeaturedNewsResponse.fromJson(List<dynamic> json) {
    featuredNewss =[];
    for (var v in json) {
      featuredNewss.add(HomeNewsModel.fromJson(v));
    }
  }

}
