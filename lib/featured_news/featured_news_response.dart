import 'package:punch_ios_android/home_news/home_model.dart';


class FeaturedNewsResponse {
  // int page;
  late List<HomeNewsModel> featuredNewss;

  FeaturedNewsResponse({
    // this.page,
     required this.featuredNewss
  });


  FeaturedNewsResponse.fromJson(List<dynamic> json) {
    featuredNewss =  <HomeNewsModel>[];
    json.forEach((v) {
      featuredNewss.add(HomeNewsModel.fromJson(v));
    });

  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   // data['page'] = this.page;
  //   if (this.latestNewss != null) {
  //     data['results'] = this.latestNewss.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}
