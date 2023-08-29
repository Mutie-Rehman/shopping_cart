// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import 'cart_model.dart';

class DBHelper {
  static Database? _db;

  // ignore: body_might_complete_normally_nullable
  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    // return null;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cart.db');
    var db = openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart (id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE,productName TEXT,initialPrice INTEGER, productPrice INTEGER , quantity INTEGER, unitTag TEXT , image TEXT )');
  }

  Future<Cart> insert(Cart cart) async {
    print(cart.toMap());
    var dbClient = await db;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List> getCartList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('cart');
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> delete(id) async {
    var dbClient = await db;

    return await dbClient!.delete(
      'cart',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await db;

    return await dbClient!.update(
      'cart',
      cart.toMap(),
      where: "id = ?",
      whereArgs: [cart.id],
    );
  }
}
