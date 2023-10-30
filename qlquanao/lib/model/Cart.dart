import 'package:firebase_database/firebase_database.dart';

class Cart {
  String idCart;
  String productID;
  String productName;
  String image;
  String color;
  String size;
  int price;
  int quantity;
  String userID;

  Cart({
    required this.idCart,
    required this.productID,
    required this.productName,
    required this.image,
    required this.color,
    required this.size,
    required this.price,
    int? quantity,
    required this.userID,
  }) : quantity = (quantity == null || quantity < 1) ? 1 : quantity;


  Cart.fromSnapshot(DataSnapshot snapshot) :
        idCart = snapshot.child('idCart').value.toString(),
        productID = snapshot.child('productID').value.toString(),
        productName = snapshot.child('productName').value.toString(),
        image = snapshot.child('image').value.toString(),
        color = snapshot.child('color').value.toString(),
        size = snapshot.child('size').value.toString(),
        price = int.parse(snapshot.child('totalAmount').value.toString()),
        quantity = int.parse(snapshot.child('quantity').value.toString()),
        userID = snapshot.child('userID').value.toString();



  toJson(){
    return {
      'idCart' : idCart,
      'productID' : productID,
      'productName' : productName,
      'productImage' : image,
      'color' : color,
      'size' : size,
      'totalAmount' : price,
      'quantity' : quantity,
      'userID' : userID};
  }

  @override
  String toString() {
    return "sản phẩm: " + " name: " + productName + " image: " + image + " size: " + size + " color: " + color + " price: " + price.toString() + " quantity: " + quantity.toString();
  }
}