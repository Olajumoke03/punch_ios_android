import 'dart:io';
import 'package:objectdb/objectdb.dart';
import 'package:objectdb/src/objectdb_storage_filesystem.dart';

class FavoriteDB  {
  // getPath() async {
  //   Directory documentDirectory = await getApplicationDocumentsDirectory();
  //   final path = documentDirectory.path + '/favorites.db';
  //   print("favorite helper path: " + path);
  //   return path;
  // }

  //Insertion
  add(Map item) async {
    // print('trying to save in FaVDb.add');
    final path = Directory.current.path + '/favorites.db';
    // Directory documentDirectory = await getApplicationDocumentsDirectory();
    // final path = documentDirectory.path + '/favorites.db';
    print("favorite helper path = " + path);

    final db = ObjectDB(FileSystemStorage(path));
    // final db = ObjectDB(getPath());

    db.insert(item).catchError((e){
      // print('failed to save in FaVDb.add :' + e.toString());
    });
    listAll();

    db.cleanup();
    await db.close();
  }

  Future<int> remove(Map item) async {
    // Directory documentDirectory = await getApplicationDocumentsDirectory();
    // final path = documentDirectory.path + '/favorites.db';
    final path = Directory.current.path + '/favorites.db';
    print("favorite helper path = " + path);

    final db = ObjectDB(FileSystemStorage(path));
    int val = await db.remove(item);
    db.cleanup();
    await db.close();
    return val;
  }

  Future<List> listAll() async {
    // Directory documentDirectory = await getApplicationDocumentsDirectory();
    // final path = documentDirectory.path + '/favorites.db';
    final path = Directory.current.path + '/favorites.db';
    print("favorite helper path = " + path);

    final db = ObjectDB(FileSystemStorage(path));
    List val = await db.find({});
    // print('items existing VDb.add :' + val.length.toString());
    // print('items existing VDb.add :' + val.toString());
    db.cleanup();
    await db.close();
    return val;
  }

  Future<List> check(Map item) async {
    // Directory documentDirectory = await getApplicationDocumentsDirectory();
    // final path = documentDirectory.path + '/favorites.db';
    final path = Directory.current.path + '/favorites.db';
    print("favorite helper path = " + path);

    final db = ObjectDB(FileSystemStorage(path));
    List val = await db.find(item);

    db.cleanup();
    await db.close();
    return val;
  }
}


