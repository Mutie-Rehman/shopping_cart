// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/cart_screen.dart';
import 'package:shopping_cart/db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Cherry',
    'Peach',
    'Mixed Fruit',
  ];
  List<String> productUnit = [
    'Per KG',
    'Per Dozen',
    'Per KG',
    'Per Dozen',
    'Per KG',
    'Per KG',
    'Per KG',
  ];
  List<int> productPrice = [
    150,
    120,
    200,
    100,
    250,
    220,
    400,
  ];
  List<String> productImage = [
    'https://img.freepik.com/premium-vector/mango-isolated-white-background_114835-24910.jpg?w=2000',
    'https://i.pinimg.com/736x/05/79/5a/05795a16b647118ffb6629390e995adb.jpg',
    'https://img.freepik.com/premium-vector/isolated-dark-grape-with-green-leaf_317810-1956.jpg?w=2000',
    'https://m.media-amazon.com/images/I/51ebZJ+DR4L._AC_UF1000,1000_QL80_.jpg',
    'https://img.freepik.com/free-vector/realistic-berries-composition-with-isolated-image-cherry-with-ripe-leaves-blank-background-vector-illustration_1284-66040.jpg?w=2000',
    'https://thumbs.dreamstime.com/b/one-peach-white-background-58569816.jpg',
    'https://5.imimg.com/data5/SP/SX/VS/SELLER-38031965/mix-fruit-flavour.png',
  ];

  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Product List"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Badge(
              backgroundColor: Colors.lightGreen.shade100,
              textColor: Colors.black,
              alignment: Alignment.topLeft,
              label: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.counter.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                },
              ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()));
                },
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: productName.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image(
                                height: 100,
                                width: 100,
                                image: NetworkImage(
                                    productImage[index].toString())),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName[index].toString(),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${productUnit[index]} ${productPrice[index]}",
                                    // "${productUnit[index]} :${productPrice[index]}-/RS",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        dbHelper!
                                            .insert(
                                          Cart(
                                              id: index,
                                              productId: index.toString(),
                                              productName:
                                                  productName[index].toString(),
                                              unitTag:
                                                  productUnit[index].toString(),
                                              image: productImage[index]
                                                  .toString(),
                                              initialPrice: productPrice[index],
                                              productPrice: productPrice[index],
                                              quantity: 1),
                                        )
                                            .then((value) {
                                          cart.addTotalPrice(double.parse(
                                              productPrice[index].toString()));
                                          cart.addCounter();
                                          print("Product is added to cart");
                                        }).onError((error, stackTrace) {
                                          print(error.toString());
                                        });
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 120,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.green,
                                          border:
                                              Border.all(color: Colors.white),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Add to cart",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
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
          ),
        ],
      ),
    );
  }
}
