import 'package:flutter/foundation.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/repository/news_repository.dart';


class DeepLinkNewsDetailsProvider extends ChangeNotifier {
  String? message;
  bool loading = true;
  bool isLoadSuccessful = false;
  bool faved = false;
  String? slug;
   HomeNewsModel newsModel = HomeNewsModel();

  Repository newsRepository = Repository();

  getFeed() async {
    newsRepository.fetchSingleNews(slug!).then((wow) {
      setNews(wow.homeNewss[0]); // it is the first item we want to display
      setLoading(false);
      setLoadSuccess(true);
    })
        .catchError((e) {
      setLoading(false);

      throw (e);
    });
  }

  void setNewsDetails(value) {
    newsModel = value;
    notifyListeners();
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setLoadSuccess(value) {
    isLoadSuccessful = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }

  void setMessage(value) {
    message = value;
    // Fluttertoast.showToast(
    //   msg: value,
    //   toastLength: Toast.LENGTH_SHORT,
    //   timeInSecForIosWeb: 1,
    // );


    // Flushbar(
    //   duration: const Duration(seconds: 3),
    //   backgroundColor: mainColor,
    //   messageColor: whiteColor,
    //   // title: "This is simple flushbar",
    //   message: value,
    // );
    notifyListeners();
  }
  String? setSlug(String slug) {
    String tamedslug = slug.replaceAll("?utm_source=OneSignal&utm_medium=web-push", "");
    // print("deeplink slug"+tamedslug);

    this.slug = tamedslug;
    return null;
  }


  String getMessage() {
    return message!;
  }

  void setNews(value) {
    newsModel = value;
    notifyListeners();
  }

  HomeNewsModel getNewsDetails() {
    return newsModel;
  }
}
