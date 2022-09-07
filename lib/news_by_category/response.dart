import 'package:punch_ios_android/home_news/home_model.dart';


class NewsByCategoryResponse {
  late List<HomeNewsModel> newsByCategorys;

  NewsByCategoryResponse({
   required this.newsByCategorys
  });

  NewsByCategoryResponse.fromJson(List<dynamic> json) {
    newsByCategorys =  <HomeNewsModel>[];
    json.forEach((v) {
      newsByCategorys.add( HomeNewsModel.fromJson(v));
    });
  }

  String toJson() {
    String data;
    data = newsByCategorys.map((v) => v.toJson()).toList().toString();
    return data;
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
