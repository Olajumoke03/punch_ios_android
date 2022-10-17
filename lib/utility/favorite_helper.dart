import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:objectdb/objectdb.dart';
import 'package:objectdb/src/objectdb_storage_filesystem.dart';

class FavoriteDB  {
  getPath() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = documentDirectory.path + '/favorites.db';
    print("favorite helper path: " + path);
    return path;
  }

  //Insertion
  add(Map item) async {
    // print('trying to save in FaVDb.add');
    final db = ObjectDB(FileSystemStorage(getPath()));
    // final db = ObjectDB(getPath());

    db.insert(item).catchError((e){
      // print('failed to save in FaVDb.add :' + e.toString());
    });
    listAll();

    db.cleanup();
    await db.close();
  }

  Future<int> remove(Map item) async {
    final db = ObjectDB(getPath());

    int val = await db.remove(item);
    db.cleanup();
    await db.close();
    return val;
  }

  Future<List> listAll() async {
    final db = ObjectDB(getPath());

    List val = await db.find({});
    // print('items existing VDb.add :' + val.length.toString());
    // print('items existing VDb.add :' + val.toString());
    db.cleanup();
    await db.close();
    return val;
  }

  Future<List> check(Map item) async {
    final db = ObjectDB(getPath());

    List val = await db.find(item);

    db.cleanup();
    await db.close();
    return val;
  }
}


