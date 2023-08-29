// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/db_helper.dart';
import 'cart_model.dart';

class CartProvider with ChangeNotifier {
  DBHelper db = DBHelper();
  late int _counter = 0;
  int get counter => _counter;
  SharedPreferences? prefs;
  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;
  List<Cart> _cart = [];
  List<Cart> get cart => _cart;

  // late List<Cart> _cart;
  // List<Cart> get cart => _cart;

  Future<List<Cart>> getData() async {
    await db.getCartList().then((value) {
      _cart = value as List<Cart>;
    });
    print("maycart is $_cart");
    notifyListeners();
    return _cart;
  }

  Future<void> _setPrefItems() async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setInt('cart_item', _counter);
    prefs!.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItems() async {
    prefs = await SharedPreferences.getInstance();
    _counter = prefs!.getInt('cart_item') ?? 0;
    _totalPrice = prefs!.getDouble('total_price') ?? 0.0;
    print(_totalPrice);
    notifyListeners();
  }

  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter() {
    if (_counter > 0) {
      _counter--;
      _setPrefItems();
      notifyListeners();
    }
  }

  int getCounter() {
    _getPrefItems();
    return _counter;
  }

//For Price of items added
  void addTotalPrice(double productPrice) {
    _totalPrice += productPrice;
    _setPrefItems();
    notifyListeners();
  }

  double removeTotalPrice(double productPrice) {
    if (_totalPrice >= productPrice) {
      _totalPrice -= productPrice;
      _setPrefItems();
      notifyListeners();
    }
    return _totalPrice;
  }

  removeCart(int id) {
    cart.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void updateTotalPrice(double newTotalPrice) {
    _totalPrice = newTotalPrice;
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefItems();
    return _totalPrice;
  }

  void removeCartItem(int itemId) {
    Cart itemToRemove = _cart.firstWhere((item) => item.id == itemId);
    _cart.removeWhere((item) => item.id == itemId);

    // Update the total price and counter accordingly
    _totalPrice -= itemToRemove.productPrice!;
    _counter = _cart.length;
    _setPrefItems();
    notifyListeners();
  }
}
