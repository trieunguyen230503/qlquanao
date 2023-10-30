import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:qlquanao/model/Order.dart';
import 'package:qlquanao/model/OrderItem.dart';
import 'package:qlquanao/model/Product.dart';
import 'package:qlquanao/model/ProductSizeColor.dart';

class RevenueProvider extends ChangeNotifier {
  String? _oderItemID;

  String? get oderItemID => _oderItemID;

  String? _oderID;

  String? get orderID => _oderID;

  String? _userID;

  String? get userID => _userID;

  String? _orderDate;

  String? get oderDate => _orderDate;

  int? _totalamount;

  int? get totalamount => _totalamount;

  bool? _status;

  bool? get status => _status;

  int? _total = 0;

  int? get total => _total;

  List<Orders>? _order;

  List<Orders>? get order => _order;

  int _countOrder = 0;

  int? get countOrder => _countOrder;

  List<Product>? _productList;

  List<Product>? get productList => _productList;

  List<int>? _totalProduct;

  List<int>? get totalProduct => _totalProduct;

  List<OrderItem>? _orderItemList;

  List<OrderItem>? get orderItemList => _orderItemList;

  List<ProductSizeColor>? _productSizeColorlist;

  List<ProductSizeColor>? get productSizeColorlist => _productSizeColorlist;

  Future getRevenue(String dateStart, String dateEnd) async {
    DateTime ds = DateFormat("dd/MM/yyyy").parse(dateStart);
    DateTime de = DateFormat("dd/MM/yyyy").parse(dateEnd);
    _order = <Orders>[];
    final DatabaseReference myOrder = FirebaseDatabase.instance.ref("orders");
    await myOrder.onValue.listen((event) async {
      _total = 0;
      _countOrder = 0;
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        if (data != null) {
          List<String> date = data['orderDate'].toString().split(" ");
          DateTime d = DateFormat("yyyy-MM-dd").parse(date[0]);
          if ((d.isAfter(ds) || d.isAtSameMomentAs(ds)) &&
              (d.isBefore(de) || d.isAtSameMomentAs(de))) {
            _order?.add(Orders(data["oderID"], data["UserID"],
                data["orderDate"], data["totalamount"], data["status"]));
            if (data['status'] == true) {
              _countOrder = _countOrder + 1;
              int? t = await data['totalamount'];
              _total = await (_total ?? 0) + (t ?? 0);
            }
          }
          print(_total);
        }
      }
    });
  }

  Future getRevenueAll() async {
    _order = <Orders>[];
    final DatabaseReference myOrder = FirebaseDatabase.instance.ref("orders");
    await myOrder.onValue.listen((event) async {
      _total = 0;
      _countOrder = 0;
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        _order?.add(Orders(data?["oderID"], data?["UserID"], data?["orderDate"],
            data?["totalamount"], data?["status"]));
        if (data != null && data['status'] == true) {
          int? t = await data['totalamount'];
          _total = await (_total ?? 0) + (t ?? 0);
          _countOrder = await _countOrder + 1;
        }
      }
    });
  }

  Future getProductAll() async {
    _productList = <Product>[];
    final DatabaseReference myOrder = FirebaseDatabase.instance.ref("Product");
    await myOrder.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        _productList?.add(Product(
            productId: data?["ProductID"],
            name: data?["Name"],
            image: data?["url"],
            price: data?["Price"],
            totalRevue: 0));
      }
    });
  }

  Future getOrderItemAll() async {
    if (_orderItemList == null) {
      _orderItemList = <OrderItem>[];
      final DatabaseReference myOrderItem =
          FirebaseDatabase.instance.ref("orderItem");
      final DatabaseReference myOrder = FirebaseDatabase.instance.ref("orders");

      await myOrder.onValue.listen((event) async {
        for (final child in event.snapshot.children) {
          final Map<dynamic, dynamic>? dataOrder = child.value as Map?;
          if (dataOrder != null && dataOrder["status"] == true) {
            //Duyệt vòng OrderItem
            await myOrderItem.onValue.listen((event) async {
              for (final child in event.snapshot.children) {
                final Map<dynamic, dynamic>? dataOrderItem =
                    child.value as Map?;
                if (dataOrderItem != null &&
                    dataOrder["orderID"] == dataOrderItem["orderID"]) {
                  _orderItemList?.add(OrderItem(
                      dataOrderItem?["orderID"],
                      dataOrderItem?["orderItemID"],
                      dataOrderItem?["productColor"],
                      dataOrderItem?["productSize"],
                      dataOrderItem?["productID"],
                      0,
                      dataOrderItem?["subTotal"],
                      dataOrderItem?["orderDate"]));
                }
              }
            });
          }
        }
      });
    }
  }

  Future getProductRevenue() async {
    for (int i = 0; i < _productList!.length; i++) {
      _productList?[i].totalRevue = 0;
    }
    int k = 0;
    final DatabaseReference myOrder = FirebaseDatabase.instance.ref("Product");
    await myOrder.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        for (int j = 0; j < _orderItemList!.length; j++) {
          print(data?["ProductID"]);
          print(_orderItemList?[j].productID);
          if (data?["ProductID"] == _orderItemList?[j].productID) {
            print("ok");
            _productList?[k].totalRevue =
                await (_productList?[k].totalRevue ?? 0) +
                    (_orderItemList?[j].subTotal ?? 0);
            print(_productList?[k].totalRevue);
          }
        }
        k++;
      }
    });
  }

  Future getProductRevenueByTime(String DateStart, String DateEnd) async {
    DateTime ds = DateFormat("dd/MM/yyyy").parse(DateStart);
    DateTime de = DateFormat("dd/MM/yyyy").parse(DateEnd);

    int k = 0;
    final DatabaseReference myOrder = FirebaseDatabase.instance.ref("Product");
    await myOrder.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        for (int j = 0; j < _orderItemList!.length; j++) {
          List<String> date =
              _orderItemList![j].orderDate.toString().split(" ");
          DateTime d = DateFormat("yyyy-MM-dd").parse(date[0]);
          if ((d.isAfter(ds) || d.isAtSameMomentAs(ds)) &&
              (d.isBefore(de) || d.isAtSameMomentAs(de))) {
            if (data?["ProductID"] == _orderItemList?[j].productID) {
              _productList?[k].totalRevue =
                  await (_productList?[k].totalRevue ?? 0) +
                      (_orderItemList?[j].subTotal ?? 0);
            }
          }
        }
        k++;
      }
    });
  }

  Future getProductSizeColor(productID) async {
    _productSizeColorlist = <ProductSizeColor>[];
    final DatabaseReference myOrder =
        FirebaseDatabase.instance.ref("ProductSizeColor");
    await myOrder.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        if (data?["ProductID"] == productID) {
          _productSizeColorlist?.add(ProductSizeColor(
              productID: data?['ProductID'],
              sizeID: data?['SizeID'],
              colorID: data?['ColorID'],
              price: 0,
              quantity: data?['Quantity']));
        }
      }
      print(_productSizeColorlist!.length);
    });
  }

  Future getProductSizeColorRevenue() async {
    final DatabaseReference myOrderItem =
        FirebaseDatabase.instance.ref("orderItem");
    final DatabaseReference myOrder = FirebaseDatabase.instance.ref("orders");

    await myOrder.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? dataOrder = child.value as Map?;
        if (dataOrder != null && dataOrder["status"] == true) {
          await myOrderItem.onValue.listen((event) async {
            for (final child in event.snapshot.children) {
              final Map<dynamic, dynamic>? data = child.value as Map?;
              if (dataOrder["orderID"] == data?["orderID"]) {
                for (int j = 0; j < _productSizeColorlist!.length; j++) {
                  //Nếu như trùng với biến thể của OrderItem thì thêm vào và đồng thời cộng số tiền doanh thu lên
                  if (_productSizeColorlist?[j].productID ==
                          data?['productID'] &&
                      _productSizeColorlist?[j].colorID ==
                          data?['productColor'] &&
                      _productSizeColorlist?[j].sizeID ==
                          data?['productSize']) {
                    _productSizeColorlist?[j].price =
                        ((_productSizeColorlist?[j].price ?? 0) +
                            (data?['subTotal'] ?? 0)) as int?;
                  }
                }
              }
            }
          });
        }
      }
    });
  }

  Future getProductSizeColorRevenueByTime(
      String DateStart, String DateEnd) async {
    DateTime ds = DateFormat("dd/MM/yyyy").parse(DateStart);
    DateTime de = DateFormat("dd/MM/yyyy").parse(DateEnd);

    final DatabaseReference myOrder = FirebaseDatabase.instance.ref("orders");

    final DatabaseReference myOrderItem =
        FirebaseDatabase.instance.ref("orderItem");

    await myOrder.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? dataOrder = child.value as Map?;
        if (dataOrder != null && dataOrder["status"] == true) {
          await myOrderItem.onValue.listen((event) async {
            for (final child in event.snapshot.children) {
              final Map<dynamic, dynamic>? data = child.value as Map?;

              if (data?["orderID"] == dataOrder["orderID"]) {
                List<String>? date = data?['orderDate'].toString().split(" ");
                DateTime d = DateFormat("yyyy-MM-dd").parse(date![0]);

                if ((d.isAfter(ds) || d.isAtSameMomentAs(ds)) &&
                    (d.isBefore(de) || d.isAtSameMomentAs(de))) {
                  for (int j = 0; j < _productSizeColorlist!.length; j++) {
                    //Nếu như trùng với biến thể của OrderItem thì thêm vào và đồng thời cộng số tiền doanh thu lên
                    if (_productSizeColorlist?[j].productID ==
                            data?['productID'] &&
                        _productSizeColorlist?[j].colorID ==
                            data?['productColor'] &&
                        _productSizeColorlist?[j].sizeID ==
                            data?['productSize']) {
                      _productSizeColorlist?[j].price =
                          ((_productSizeColorlist?[j].price ?? 0) +
                              (data?['subTotal'] ?? 0)) as int?;
                    }
                  }
                }
              }
            }
          });
        }
      }
    });
  }
}
