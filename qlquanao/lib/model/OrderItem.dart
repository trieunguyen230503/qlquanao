import 'package:firebase_database/firebase_database.dart';

class OrderItem {
  String? _orderID;

  String? get orderID => _orderID;

  String? _orderItemID;

  String? get orderItemID => _orderItemID;

  String? _productColor;

  String? get productColor => _productColor;

  // Triều
  String? _productSize;

  String? get productSize => _productSize;

  String? image;

  String? _productID;

  String? get productID => _productID;

  String? productName;

  int? _quantity;

  int? get quantity => _quantity;

  int? _subTotal;

  int? get subTotal => _subTotal;

  String? _orderDate;

  String? get orderDate => _orderDate;

  OrderItem(
      this._orderID,
      this._orderItemID,
      this._productColor,
      this._productSize,
      this._productID,
      this._quantity,
      this._subTotal,
      this._orderDate);

  OrderItem.all(
      this._orderItemID,
      this._orderID,
      this._productID,
      this.productName,
      this.image,
      this._productSize,
      this._productColor,
      this._orderDate,
      this._quantity,
      this._subTotal);

  OrderItem.fromSnapshot(DataSnapshot snapshot)
      : _orderItemID = snapshot.child("orderItemID").value.toString(),
        _orderID = snapshot.child("orderID").value.toString(),
        _productID = snapshot.child("productID").value.toString(),
        productName = snapshot.child("productName").value.toString(),
        image = snapshot.child("productImage").value.toString(),
        _productSize = snapshot.child("productSize").value.toString(),
        _productColor = snapshot.child("productColor").value.toString(),
        _orderDate = snapshot.child("orderDate").value.toString(),
        _quantity = int.parse(snapshot.child("quantity").value.toString()),
        _subTotal = int.parse(snapshot.child("subTotal").value.toString());

  toJson() {
    return {
      'orderItemID': orderItemID,
      'orderID': orderID,
      'productID': productID,
      'productName': productName,
      'productImage': image,
      'productSize': _productSize,
      'productColor': _productColor,
      'quantity': quantity,
      'subTotal': subTotal,
      'orderDate': orderDate,
    };
  }
}
