// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/db_helper.dart';
import 'cart_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  late Future<List<Cart>> future;

  @override
  void initState() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    future = cart.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("My Products"),
      ),
      body: Column(
        children: [
          Consumer<CartProvider>(builder: (context, provider, _) {
            return FutureBuilder(
                future: future,
                builder: (context, AsyncSnapshot snapshot) {
                  return snapshot.connectionState != ConnectionState.waiting
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: provider.cart.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Image(
                                              height: 100,
                                              width: 100,
                                              image: NetworkImage(provider
                                                  .cart[index].image
                                                  .toString())),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      provider.cart[index]
                                                          .productName
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 24,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Consumer<CartProvider>(
                                                      builder: (context,
                                                          cartProvider, _) {
                                                        return GestureDetector(
                                                          onTap: () async {
                                                            await dbHelper!
                                                                .delete(provider
                                                                    .cart[index]
                                                                    .id);
                                                            cart.removeCounter();

                                                            cart.removeTotalPrice(
                                                                provider
                                                                    .cart[index]
                                                                    .productPrice!
                                                                    .toDouble());
                                                            cart.removeCart(provider
                                                                .cart[index]
                                                                .id!); // Use productPrice instead of initialPrice
                                                          },
                                                          child: const Icon(
                                                              Icons.delete),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${provider.cart[index].unitTag}${provider.cart[index].productPrice}",
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            int quantity = provider
                                                                    .cart[index]
                                                                    .quantity ??
                                                                0;
                                                            int price = provider
                                                                    .cart[index]
                                                                    .initialPrice ??
                                                                0;
                                                            if (quantity > 1) {
                                                              quantity--;
                                                              int newPrice =
                                                                  price *
                                                                      quantity;
                                                              dbHelper!
                                                                  .updateQuantity(Cart(
                                                                      id: provider
                                                                          .cart[
                                                                              index]
                                                                          .id,
                                                                      productId: provider
                                                                          .cart[
                                                                              index]
                                                                          .productId,
                                                                      productName: provider
                                                                          .cart[
                                                                              index]
                                                                          .productName,
                                                                      unitTag: provider
                                                                          .cart[
                                                                              index]
                                                                          .unitTag,
                                                                      image: provider
                                                                          .cart[
                                                                              index]
                                                                          .image,
                                                                      initialPrice: provider
                                                                          .cart[
                                                                              index]
                                                                          .initialPrice,
                                                                      productPrice:
                                                                          newPrice,
                                                                      quantity:
                                                                          quantity))
                                                                  .then(
                                                                      (value) {
                                                                cart.removeTotalPrice(provider
                                                                    .cart[index]
                                                                    .initialPrice!
                                                                    .toDouble());
                                                                cart.removeCounter();
                                                              }).onError((error,
                                                                      stackTrace) {
                                                                print(error
                                                                    .toString());
                                                              });
                                                            }
                                                          },
                                                          child: const Icon(
                                                              Icons.remove),
                                                        ),
                                                        Text(provider
                                                            .cart[index]
                                                            .quantity
                                                            .toString()),
                                                        InkWell(
                                                          onTap: () {
                                                            int quantity = provider
                                                                    .cart[index]
                                                                    .quantity ??
                                                                0;
                                                            int price = provider
                                                                    .cart[index]
                                                                    .initialPrice ??
                                                                0;
                                                            quantity++;
                                                            int newPrice =
                                                                price *
                                                                    quantity;
                                                            dbHelper!
                                                                .updateQuantity(Cart(
                                                                    id: provider
                                                                        .cart[
                                                                            index]
                                                                        .id,
                                                                    productId: provider
                                                                        .cart[
                                                                            index]
                                                                        .productId,
                                                                    productName: provider
                                                                        .cart[
                                                                            index]
                                                                        .productName,
                                                                    unitTag: provider
                                                                        .cart[
                                                                            index]
                                                                        .unitTag,
                                                                    image: provider
                                                                        .cart[
                                                                            index]
                                                                        .image,
                                                                    initialPrice: provider
                                                                        .cart[
                                                                            index]
                                                                        .initialPrice,
                                                                    productPrice:
                                                                        newPrice,
                                                                    quantity:
                                                                        quantity))
                                                                .then((value) {
                                                              cart.addTotalPrice(
                                                                  double.parse(provider
                                                                      .cart[
                                                                          index]
                                                                      .initialPrice
                                                                      .toString()));
                                                              cart.addCounter();
                                                            }).onError((error,
                                                                    stackTrace) {
                                                              print(error
                                                                  .toString());
                                                            });
                                                          },
                                                          child: const Icon(
                                                              Icons.add),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        )
                      : const Text(
                          "TEXT",
                        );
                });
          }),
          // Consumer<CartProvider>(
          //   builder: (context, value, child) {
          //     return Visibility(
          //       visible: value.totalPrice > 0,
          //       child: Column(
          //         children: [
          ReusableWidget(
            title: "Sub Total: ",
            value: 2.toStringAsFixed(2),
          ),
          //   ],
          // ),
          // );
          // },
          //),
        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              provider.totalPrice.toString(),
              style: Theme.of(context).textTheme.titleSmall,
            )
          ],
        ),
      );
    });
  }
}
