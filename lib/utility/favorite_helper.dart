


import 'dart:convert';
import 'dart:io';
import 'package:objectdb/objectdb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:objectdb/src/objectdb_storage_filesystem.dart';

class FavoriteDB {

  late String path;


  getPath() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    path = documentDirectory.path + '/favorites.db';
    print("favorite helper path: " + path);
    return path;
  }
  FavoriteDB(){
    getPath();
  }


  //Insertion
  add(Map item) async {
    print('trying to save in FaVDb.add');
    final db = ObjectDB(FileSystemStorage(path));

    db.insert(item).catchError((e){
      print('failed to save in FaVDb.add :' + e.toString());
    });

    listAll();

    await db.close();
  }

  // Future<int> remove(Map item) async {
  //   final db = ObjectDB(FileSystemStorage(path));
  //   // int val = await db.remove((item ));//original doesn;t work
  //   // int val = await db.remove({item});//doesnt work
  //   int val = await db.remove({item: "item" }); //doesnt work Unhandled Exception: Converting object to an encodable object failed: _LinkedHashMap len:1
  //   // int val = await db.remove({"id": item });//doesnt work.. unexpected character error {"id-{"id":{"id":1415085}}
  //
  //   // int val = await db.remove(json.decode(item.toString()));// deesn't work
  //   // int val = await db.remove(jsonDecode(item.toString()));//doesnt work
  //   print("val remove: " + val.toString());
  //
  //   await db.close();
  //   return val;
  // }

  Future<int> remove(Map item) async {
    final db = ObjectDB(FileSystemStorage(path));
      int val = await db.remove({item: "item" }); // works but  Unhandled Exception: Converting object to an encodable object failed: _LinkedHashMap len:1
    print("val remove: " + item.toString());

    await db.close();
    return val;
  }

  Future<List> listAll() async {
    final db = ObjectDB(FileSystemStorage(path));
    List val = await db.find({});
    print('items existing VDb.add :' + val.length.toString());
    print('items existing VDb.add :' + val.toString());
    await db.close();
    return val;
  }

  Future<List> check(Map item) async {
    final db = ObjectDB(FileSystemStorage(path));
    List val = await db.find(item);

    await db.close();
    return val;
  }
}
