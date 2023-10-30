import 'package:firebase_database/firebase_database.dart';

class Product {
  final String productId;
  final String name;
  final String image;

  final int price;
  String? material;
  int? totalRevue;
  String? description;
  String? category;
  int? promoPrice;

  Product({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.totalRevue,
  });

  Product.qui(this.productId, this.name, this.category, this.description,
      this.material, this.price, this.promoPrice, this.image);

  String? key;
  ProductData? productData;

  Product.all(this.productId, this.name, this.image, this.price,
      {this.key, this.productData});

  Product.fromSnapshot(DataSnapshot snapshot)
      : productId = snapshot.child('ProductID').value.toString(),
        name = snapshot.child('Name').value.toString(),
        category = snapshot.child('Category').value.toString(),
        description = snapshot.child('Description').value.toString(),
        material = snapshot.child('Material').value.toString(),
        image = snapshot.child('url').value.toString(),
        price = int.parse(snapshot.child('Price').value.toString()),
        promoPrice = int.parse(snapshot.child('PromoPrice').value.toString());

  toJson() {
    return {
      'ProductID': productId,
      'Name': name,
      'Category': category,
      'Description': description,
      'Material': material,
      'Price': price,
      'PromoPrice': promoPrice,
      'url': image
    };
  }
}

class ProductData {
  String? uid;
  String? name;
  double? price;
  double? promoprice;
  String? category;
  String? material;
  String? description;
  String? url;

  ProductData(
      {this.uid,
      this.name,
      this.price,
      this.promoprice,
      this.category,
      this.material,
      this.description,
      this.url});

  ProductData.fromJson(Map<dynamic, dynamic> json) {
    uid = json["ProductID"];
    name = json["Name"];
    price = json["Price"];
    promoprice = json["PromoPrice"];
    category = json["Category"];
    material = json["Material"];
    description = json["Description"];
    url = json["url"];
  }
}
