import 'home_model.dart';

class HomeNewsResponse {
  late List<HomeNewsModel> homeNewss;

  HomeNewsResponse({ required this.homeNewss});

  HomeNewsResponse.fromJson(List<dynamic> json) {
    homeNewss =  <HomeNewsModel>[];
    json.forEach((v) {
      homeNewss.add(HomeNewsModel.fromJson(v));
    });
  }

  String toJson() {
    String data;
    data = homeNewss.map((v) => v.toJson()).toList().toString();
    return data;
  }
}