import 'package:firebase_database/firebase_database.dart';

class ProductSizeColor {
  String? uid;

  final String productID;

  final String sizeID;

  final String colorID;

  int? price;

  final int quantity;

  String? url;

  ProductSizeColor(
      {required this.productID,
      required this.sizeID,
      required this.colorID,
      required this.price,
      required this.quantity,
      required this.url});

  String? key;
  ProductSizeColorData? productSizeColorData;

  ProductSizeColor.all(this.productID, this.sizeID, this.colorID, this.quantity,
      {this.key, this.productSizeColorData});
}

class ProductSizeColorData {
  String? uid;
  String? productID;
  String? sizeID;
  String? colorID;
  double? price;
  int? quantity;
  String? url;

  ProductSizeColorData(
      {this.uid,
      this.productID,
      this.sizeID,
      this.colorID,
      this.price,
      this.quantity,
      this.url});

  ProductSizeColorData.fromSnapshot(DataSnapshot snapshot)
      : uid = snapshot.child('ProductSizeColorID').value.toString(),
        productID = snapshot.child('ProductID').value.toString(),
        sizeID = snapshot.child('SizeID').value.toString(),
        colorID = snapshot.child('ColorID').value.toString(),
        price = double.parse(snapshot.child('Price').value.toString()),
        quantity = int.parse(snapshot.child('Quantity').value.toString()),
        url = snapshot.child('url').value.toString();

  ProductSizeColorData.fromJson(Map<dynamic, dynamic> json) {
    uid = json["ProductSizeColorID"];
    productID = json["ProductID"];
    sizeID = json["SizeID"];
    colorID = json["ColorID"];
    price = json["Price"];
    quantity = json["Quantity"];
    url = json["url"];
  }

  toJson(){
    return {
      'ProductSizeColorID' : uid,
      'ProductID' : productID,
      'SizeID' : sizeID,
      'ColorID' : colorID,
      'Price' : price,
      'Quantity' : quantity,
      'url' : url};
  }
}
