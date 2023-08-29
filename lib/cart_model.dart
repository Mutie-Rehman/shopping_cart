class Cart {
  //id will be the primary key
  late final int? id;
  //product id will be the id of the product we have, index will be used as the prodct id
  final String? productId;
  //prodcut name will be the name of the product we have
  final String? productName;
  //the unit tag will be kg and dozen in our case
  final String? unitTag;
  //the url of the image we have and we will store it in our database
  final String? image;
  //this is the initial price which is given
  final int? initialPrice;
  //this will be the price of items we have added in the cart as the whole
  final int? productPrice;
  //how much we want the product
  final int? quantity;

//constructer of the cart class
  Cart(
      {required this.id,
      required this.productId,
      required this.productName,
      required this.unitTag,
      required this.image,
      required this.initialPrice,
      required this.productPrice,
      required this.quantity});

  Cart.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        productId = res['productId'],
        productName = res['productName'],
        unitTag = res['unitTag'],
        image = res['image'],
        initialPrice = res['iinitialPriced'],
        productPrice = res['productPrice'],
        quantity = res['quantity'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'unitTag': unitTag,
      'image': image,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'quantity': quantity,
    };
  }
}
