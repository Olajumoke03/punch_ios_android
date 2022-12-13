// import 'package:flutter/foundation.dart';
// import 'favorite_helper.dart';
//
// class FavoritesProvider extends ChangeNotifier {
//   late String message;
//   List posts = [];
//   bool loading = true;
//   var db = FavoriteDB();
//
//   getFeed() async {
//     setLoading(true);
//     posts.clear();
//     List c = await db.listAll();
//     posts.addAll(c);
//     setLoading(false);
//   }
//
//   void setLoading(value) {
//     loading = value;
//     notifyListeners();
//   }
//
//   bool isLoading() {
//     return loading;
//   }
//
//   void setMessage(value) {
//     message = value;
//     // Fluttertoast.showToast(
//     //   msg: value,
//     //   toastLength: Toast.LENGTH_SHORT,
//     //   timeInSecForIosWeb: 1,
//     // );
//     notifyListeners();
//   }
//
//   String getMessage() {
//     return message;
//   }
//
//   void setPosts(value) {
//     posts = value;
//     notifyListeners();
//   }
//
//   List getPosts() {
//     return posts;
//   }
// }

import 'package:flutter/foundation.dart';
import 'favorite_helper.dart';


class FavoritesProvider extends ChangeNotifier {
  late String message;
  List posts = [];
  bool loading = true;
  var db = FavoriteDB();

  getFeed() async {
    setLoading(true);
    posts.clear();
    List c = await db.listAll();
    posts.addAll(c);
    setLoading(false);

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

  void setPosts(value) {
    posts = value;
    notifyListeners();
  }

  List getPosts() {
    return posts;
  }
}

