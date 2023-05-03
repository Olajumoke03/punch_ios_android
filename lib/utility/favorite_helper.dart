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
  //
  // getPath() async {
  //   Directory documentDirectory = await getApplicationDocumentsDirectory();
  //   final path = documentDirectory.path + '/favorites.db';
  //   print("favorite helper path: " + path);
  //
  //   return documentDirectory.path;
  // }

  Future<String>  getPath() async {
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      final path = documentDirectory.path + '/favorites.db';

      print("favorite helper path: " + path);

      return path;
  }

  // getdata(String userUrl) async {
  //   //JSON Parser
  //   var url = 'https://api.shrtco.de/v2/shorten?url=$userUrl';
  //   var respons = await http.get(url);
  //   var result = jsonDecode(respons.body);
  //   var shortlink = result['result']['short_link']; //dictionary parse
  //   print(shortlink);
  //   return shortlink;
  // }
  //
  // Future<String> getdata(String userUrl) async {
  //   //JSON Parser
  //   var url = 'https://api.shrtco.de/v2/shorten?url=$userUrl';
  //   var respons = await http.get(url);
  //   var result = jsonDecode(respons.body);
  //   var shortlink = result['result']['short_link']; //dictionary parse
  //   print(shortlink);
  //   return shortlink;
  // }



  // Future<String> getPath() async {
  //   Directory documentDirectory = await getApplicationDocumentsDirectory();
  //   final path = documentDirectory.path + '/favorites.db';
  //   print("favorite helper path: " + path);
  //   File(path).create(recursive: true);
  //
  //   return path;
  // }

  //Insertion

  //Insertion
  add(Map item) async {
    print('trying to save in FaVDb.add');
    // final db = ObjectDB(await getPath());
    final db = ObjectDB(FileSystemStorage(await getPath()));

    db.insert(item).catchError((e){
      print('failed to save in FaVDb.add :' + e.toString());
    });
    listAll();
    db.cleanup();
    await db.close();
  }

  // add(Map item) async {
  //   print('trying to save in FaVDb.add');
  //   final db = ObjectDB(await getPath());
  //      db.insert(item);
  //
  //   listAll();
  //   db.cleanup();
  //   await db.close();
  // }

  Future<int> remove(Map item) async {
    // final db = ObjectDB(await getPath());
   final db = ObjectDB(FileSystemStorage(await getPath()));

    int val = await db.remove(item);
    db.cleanup();
    await db.close();
    return val;
  }

  Future<List> listAll() async {
    // final db = ObjectDB(await getPath());
    final db = ObjectDB(FileSystemStorage(await getPath()));

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

    List val = await db.find(item);
    db.cleanup();
    await db.close();
    return val;
  }

}
