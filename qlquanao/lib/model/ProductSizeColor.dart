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
      required this.quantity});

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

  ProductSizeColorData.fromJson(Map<dynamic, dynamic> json) {
    uid = json["ProductSizeColorID"];
    productID = json["ProductID"];
    sizeID = json["SizeID"];
    colorID = json["ColorID"];
    price = json["Price"];
    quantity = json["Quantity"];
    url = json["url"];
  }
}
