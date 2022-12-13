// import 'dart:io';
// import 'package:objectdb/objectdb.dart';
// import 'package:objectdb/src/objectdb_storage_filesystem.dart';
//
// class FavoriteDB  {
//   // getPath() async {
//   //   Directory documentDirectory = await getApplicationDocumentsDirectory();
//   //   final path = documentDirectory.path + '/favorites.db';
//   //   print("favorite helper path: " + path);
//   //   return path;
//   // }
//
//   //Insertion
//   add(Map item) async {
//     // print('trying to save in FaVDb.add');
//     final path = Directory.current.path + '/favorites.db';
//     // Directory documentDirectory = await getApplicationDocumentsDirectory();
//     // final path = documentDirectory.path + '/favorites.db';
//     print("favorite helper path = " + path);
//
//     final db = ObjectDB(FileSystemStorage(path));
//     // final db = ObjectDB(getPath());
//
//     db.insert(item).catchError((e){
//       // print('failed to save in FaVDb.add :' + e.toString());
//     });
//     listAll();
//
//     db.cleanup();
//     await db.close();
//   }
//
//   Future<int> remove(Map item) async {
//     // Directory documentDirectory = await getApplicationDocumentsDirectory();
//     // final path = documentDirectory.path + '/favorites.db';
//     final path = Directory.current.path + '/favorites.db';
//     print("favorite helper path = " + path);
//
//     final db = ObjectDB(FileSystemStorage(path));
//     int val = await db.remove(item);
//     db.cleanup();
//     await db.close();
//     return val;
//   }
//
//   Future<List> listAll() async {
//     // Directory documentDirectory = await getApplicationDocumentsDirectory();
//     // final path = documentDirectory.path + '/favorites.db';
//     final path = Directory.current.path + '/favorites.db';
//     print("favorite helper path = " + path);
//
//     final db = ObjectDB(FileSystemStorage(path));
//     List val = await db.find({});
//     // print('items existing VDb.add :' + val.length.toString());
//     // print('items existing VDb.add :' + val.toString());
//     db.cleanup();
//     await db.close();
//     return val;
//   }
//
//   Future<List> check(Map item) async {
//     // Directory documentDirectory = await getApplicationDocumentsDirectory();
//     // final path = documentDirectory.path + '/favorites.db';
//     final path = Directory.current.path + '/favorites.db';
//     print("favorite helper path = " + path);
//
//     final db = ObjectDB(FileSystemStorage(path));
//     List val = await db.find(item);
//
//     db.cleanup();
//     await db.close();
//     return val;
//   }
// }
//
//

import 'dart:io';
import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:objectdb/src/objectdb_storage_filesystem.dart';

class FavoriteDB {

  // getPath() async {
  //   Directory documentDirectory = await getApplicationDocumentsDirectory();
  //
  //   final path = documentDirectory.path + '/favorites.db';
  //   print("favorite helper path: " + path);
  //   File(path).create(recursive: true);
  //
  //   return path;
  // }

  Future<String> getPath() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    final path = documentDirectory.path + '/favorites.db';
    print("favorite helper path: " + path);
    File(path).create(recursive: true);

    return path;
  }

  //Insertion
  add(Map item) async {
    print('trying to save in FaVDb.add');
    // final db = ObjectDB(await getPath());
    final db = ObjectDB(FileSystemStorage(await getPath()));

    // db.open();

    db.insert(item).catchError((e){
      print('failed to save in FaVDb.add :' + e.toString());
    });
    listAll();

    db.cleanup();
    await db.close();
  }

  Future<int> remove(Map item) async {
    // final db = ObjectDB(await getPath());
    final db = ObjectDB(FileSystemStorage(await getPath()));

    // db.open();
    int val = await db.remove(item);
    db.cleanup();
    await db.close();
    return val;
  }

  Future<List> listAll() async {
    // final db = ObjectDB(await getPath());
    final db = ObjectDB(FileSystemStorage( await getPath()));

    // db.open();
    List val = await db.find({});
    print('items existing VDb.add :' + val.length.toString());
    print('items existing VDb.add :' + val.toString());
    db.cleanup();
    await db.close();
    return val;
  }

  Future<List> check(Map item) async {
    // final db = ObjectDB(await getPath());
      final db = ObjectDB(FileSystemStorage(await getPath()));

    // db.open();
    List val = await db.find(item);

    db.cleanup();
    await db.close();
    return val;
  }
}
