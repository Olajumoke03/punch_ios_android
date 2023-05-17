// // import 'dart:io';
// // import 'package:objectdb/objectdb.dart';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:objectdb/src/objectdb_storage_filesystem.dart';
// //
// //
// // class FavoriteDB {
// //
// //   Future<String>  getPath() async {
// //       Directory documentDirectory = await getApplicationDocumentsDirectory();
// //       final path = documentDirectory.path + '/favorites.db';
// //
// //       print("favorite helper path: " + path);
// //       return path;
// //   }
// //
// //
// //   add(Map item) async {
// //     print('trying to save in FaVDb.add');
// //     // final db = ObjectDB(await getPath());
// //     final db = ObjectDB(FileSystemStorage(await getPath()));
// //
// //     db.insert(item).catchError((e){
// //       print('failed to save in FaVDb.add :' + e.toString());
// //     });
// //     listAll();
// //     db.cleanup();
// //     await db.close();
// //   }
// //
// //   Future<int> remove(Map item) async {
// //     // final db = ObjectDB(await getPath());
// //    final db = ObjectDB(FileSystemStorage(await getPath()));
// //
// //     int val = await db.remove(item);
// //     db.cleanup();
// //     await db.close();
// //     return val;
// //   }
// //
// //   Future<List> listAll() async {
// //     // final db = ObjectDB(await getPath());
// //     final db = ObjectDB(FileSystemStorage(await getPath()));
// //
// //     List val = await db.find({});
// //     print('items existing VDb.add :' + val.length.toString());
// //     print('items existing VDb.add :' + val.toString());
// //     db.cleanup();
// //     await db.close();
// //     return val;
// //   }
// //
// //   Future<List> check(Map item) async {
// //     // final db = ObjectDB(await getPath());
// //     final db = ObjectDB(FileSystemStorage(await getPath()));
// //
// //     List val = await db.find(item);
// //     db.cleanup();
// //     await db.close();
// //     return val;
// //   }
// //
// // }
// //
//
//------------------------------------------
// import 'dart:io';
// import 'package:objectdb/objectdb.dart';
// import 'package:objectdb/src/objectdb_storage_filesystem.dart';
// import 'package:path_provider/path_provider.dart';
//
// class FavoriteDB {
//   var path ="";
//
//   FavoriteDB(){getPath();}
//
//   getPath() async {
//     Directory documentDirectory = await getApplicationDocumentsDirectory();
//     path = documentDirectory.path + '/favorites.db';
//     print(path);
//     //return path;
//   }
//
//   //Insertion
//   // add(Map item) async {
//   //   print('trying to save in FaVDb.add');
//   //   final db = ObjectDB(FileSystemStorage(path));
//   //   print(path);
//   //   // db.open();
//   //
//   //   // db.insert(item);
//   //   db.insert(item).catchError((e){
//   //     print('failed to save in FaVDb.add :' + e.toString());
//   //   });
//   //   // db.tidy();
//   //   await db.close();
//   // }
//
//   add(Map item) async {
//     print('trying to save in FaVDb.add');
//     // final db = ObjectDB(await getPath());
//     final db = ObjectDB(FileSystemStorage( path));
//
//     // db.insert(item);
//
//     db.insert(item).catchError((e){
//       print('failed to save in FaVDb.add :' + e.toString());
//     });
//
//     listAll();
//     db.cleanup();
//     await db.close();
//   }
//
//   Future<int> remove(Map item) async {
//     print('trying to remove in FaVDb.add');
//
//     final db = ObjectDB(FileSystemStorage(path));
//     // db.open();
//
//     int val = await db.remove(item);
//     // db.tidy();
//     db.cleanup();
//
//     await db.close();
//     return val;
//   }
//
//
//   Future<List> listAll() async {
//     final db = ObjectDB(FileSystemStorage(path));
//     // db.open();
//     List val = await db.find({});
//     print('items existing VDb.add :' + val.length.toString());
//     print('items existing VDb.add :' + val.toString());
//     // db.tidy();
//     await db.close();
//     return val;
//
//   }
//
//   Future<List> check(Map item) async {
//     final db = ObjectDB(FileSystemStorage(path));
//     // db.open();
//     List val = await db.find(item);
//     // db.tidy();
//     await db.close();
//     return val;
//   }
// }



import 'dart:io';
import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:objectdb/src/objectdb_storage_filesystem.dart';

class FavoriteDB {

  // var path ="";
  // FavoriteDB(){
  //   getPath();
  // }
  //
  // getPath() async {
  //   Directory documentDirectory = await getApplicationDocumentsDirectory();
  //   path = documentDirectory.path + '/favorites.db';
  //   print("favorite helper path: " + path);
  //   //return path;
  // }

  // final path = Directory.current.path + '/favorites.db';
  final path = Directory.current.path;


  //Insertion
  add(Map item) async {
    print('trying to save in FaVDb.add');
    final db = ObjectDB(FileSystemStorage(path));
    print("favorite helper path: " + path);

    print('saved in favorite helper');

    db.insert(item).catchError((e){
      print('failed to save in FaVDb.add :' + e.toString());
    });

    listAll();

    db.cleanup();
    await db.close();
  }

  Future<int> remove(Map item) async {
    print('trying to remove in favorite helper');

    final db = ObjectDB(FileSystemStorage(path));
    int val = await db.remove(item);
    db.cleanup();
    await db.close();
    return val;
  }

  Future<List> listAll() async {
    final db = ObjectDB(FileSystemStorage(path));
    List val = await db.find({});
    print('items existing VDb.add :' + val.length.toString());
    print('items existing VDb.add :' + val.toString());
    db.cleanup();
    await db.close();
    return val;
  }

  Future<List> check(Map item) async {
    final db = ObjectDB(FileSystemStorage(path));
    List val = await db.find(item);
    db.cleanup();
    await db.close();
    return val;
  }
}

