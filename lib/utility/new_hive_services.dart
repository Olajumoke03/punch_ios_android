import 'package:hive/hive.dart';
import 'package:punch_ios_android/home_news/home_model.dart';

class NewHiveService {
 late Box hiveBox;
late  List bookmarks;

  NewHiveService() {
    initBox();
  }

  initBox() async {
    hiveBox = await Hive.openBox('bookmarks');
  }

  Future addToBookmark(HomeNewsModel homeNewsModel, bool doesBookmarkExist) async {
    bookmarks = getBookmarks();
    bookmarks.add(homeNewsModel);
    await hiveBox.put("bookmarks", bookmarks);
    return doesBookmarkExist = true;
  }

  Future removeFromBookmark(HomeNewsModel homeNewsModel, bool doesBookmarkExist) async {
    bookmarks = getBookmarks();
    var removableIndex = 0;
    bookmarks.asMap().forEach((index, element) {
      if (element["publishedAt"] == homeNewsModel) {
        removableIndex = index;
      }
    });
    bookmarks.removeAt(removableIndex);
    await hiveBox.put("bookmarks", bookmarks);
    return doesBookmarkExist = false;
  }

  getBookmarks() {
    return hiveBox.get("bookmarks") ?? [];
  }
}
