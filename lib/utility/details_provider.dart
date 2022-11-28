import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:punch_ios_android/home_news/home_model.dart';
import 'package:punch_ios_android/model/latest_news_model.dart';



import 'favorite_helper.dart';

class DetailsProvider extends ChangeNotifier {
 late String message;
  // CategoryFeed related = CategoryFeed();
  bool loading = true;
 late LatestNewsModel entry;
  var favDB = FavoriteDB();

  bool faved = false;

  static var httpClient = HttpClient();

  // suspected culpruit
  Future<bool> checkFav(int id) async {
    List c = await favDB.check({"id": id});
    // print('its liking :' +c.isNotEmpty.toString());
    // print('length : ' + c.length.toString());
    if (c.isNotEmpty) {
      // print('i exist'); // if c is not empty means that something was found
      return true;
    } else {
      // print('i dont exist'); // this means that it didntn find anyhinh
      return false;
    }

  }

  addFav(HomeNewsModel item) async {
    // print('trying to save iin adFav');
    await favDB.add({"id": item.id, "item": item.toJson()}); // this adds
    checkFav(item.id!);
  }

  removeFav(int id) async {
    favDB.remove({"id": id}).then((v) {
      // print(v);
      checkFav(id);
    });
  }

  void setLoading(value) {
    loading = value;
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
    notifyListeners();
  }

  String getMessage() {
    return message;
  }


  void setEntry(value) {
    entry = value;
    notifyListeners();
  }

  void setFaved(value) {
    faved = value;
    notifyListeners();
  }
}











