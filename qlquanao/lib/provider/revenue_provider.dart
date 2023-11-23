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

  int _total = 0;

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

  bool check = false;
  int count = 0;

  Future getRevenue(String dateStart, String dateEnd) async {
    _order = <Orders>[];

    DateTime ds = DateFormat("dd/MM/yyyy").parse(dateStart);
    DateTime de = DateFormat("dd/MM/yyyy").parse(dateEnd);
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
            if (data['status'] == true) {
              _order?.add(Orders(
                  data["oderID"],
                  data["UserID"],
                  data["orderDate"],
                  data["totalamount"],
                  "Confirm",
                  data['userName']));
              _countOrder = _countOrder + 1;
              int? t = await data['totalamount'];
              _total = await (_total ?? 0) + (t ?? 0);
            } else {
              _order?.add(Orders(
                  data["oderID"],
                  data["UserID"],
                  data["orderDate"],
                  data["totalamount"],
                  "",
                  data['userName']));
            }
          }
        }
      }
    });
  }

  Future clearRevenue() async {
    _order = <Orders>[];
  }

  Future getRevenueAll() async {
    _order = <Orders>[];

    final DatabaseReference myOrder = FirebaseDatabase.instance.ref("orders");
    await myOrder.onValue.listen((event) async {
      _total = 0;
      _countOrder = 0;
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        if (data?["status"] == true) {
          _order?.add(Orders(
              data?["oderID"],
              data?["UserID"],
              data?["orderDate"],
              data?["totalamount"],
              "Confirm",
              data?['userName']));
        } else {
          _order?.add(Orders(data?["oderID"], data?["UserID"],
              data?["orderDate"], data?["totalamount"], "", data?['userName']));
        }
        print(data?['totalamount']);
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
            price: data?["PromoPrice"],
            totalRevue: 0));
      }
    });
  }

  Future cleanProductRevenue() async {
    _productList = <Product>[];
    _orderItemList = null;
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
                      dataOrderItem?["quantity"],
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
      _productList?[i].totalRevue = await 0;
    }
    _total = await 0;
    int k = await 0;
    final DatabaseReference myOrder = FirebaseDatabase.instance.ref("Product");
    await myOrder.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? data = child.value as Map?;
        for (int j = 0; j < _orderItemList!.length; j++) {
          if (data?["ProductID"] == _orderItemList?[j].productID &&
              k < productList!.length) {
            _productList?[k].totalRevue =
                await (_productList?[k].totalRevue ?? 0) +
                    (_orderItemList?[j].subTotal ?? 0) *
                        (_orderItemList?[j].quantity ?? 0);
            print(_productList?[k].totalRevue);
            _total += _orderItemList![j].subTotal! *
                (_orderItemList?[j].quantity ?? 0);
          }
        }
        k++;
      }
    });
  }

  Future getProductRevenueByTime(String DateStart, String DateEnd) async {
    for (int i = 0; i < _productList!.length; i++) {
      _productList?[i].totalRevue = 0;
    }
    _total = 0;

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
            if (data?["ProductID"] == _orderItemList?[j].productID &&
                k < productList!.length) {
              _productList?[k].totalRevue =
                  await (_productList?[k].totalRevue ?? 0) +
                      (_orderItemList?[j].subTotal ?? 0) *
                          (_orderItemList?[j].quantity ?? 0);
              _total += _orderItemList![j].subTotal! *
                  (_orderItemList?[j].quantity ?? 0);
            }
          }
        }
        k++;
      }
    });
  }

  Future<String> getNameById(String id, String node) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('$node/$id/Name');
    DatabaseEvent event = await ref.once();
    String s = event.snapshot.value.toString();
    return s.toString();
  }

  Future getProductSizeColor(productID) async {
    int count = 0;
    if (_productSizeColorlist == null) {
      _productSizeColorlist = await <ProductSizeColor>[];
      final DatabaseReference myOrder =
      await FirebaseDatabase.instance.ref("ProductSizeColor");
      print(productID);
      await myOrder.onValue.listen((event) async {
        for (final child in event.snapshot.children) {
          final Map<dynamic, dynamic>? data = child.value as Map?;
          if (data?["ProductID"] == productID) {
            String getSize = await getNameById(data?['SizeID'], 'Size');
            String getColor = await getNameById(data?['ColorID'], 'Color');
            _productSizeColorlist?.add(ProductSizeColor(
                productID: data?['ProductID'],
                sizeID: getSize,
                colorID: getColor,
                price: 0,
                quantity: data?['Quantity'],
                url: data?['url']));
          }
          await count++;
        }
      });
    }
  }

  Future cleanProductSizeColor() async {
    _productSizeColorlist = await null;
  }

  Future getProductSizeColorRevenue(String? pid) async {
    // for (int i = 0; i < productSizeColorlist!.length; i++) {
    //   productSizeColorlist?[i].price = 0;
    // }

    final Query myOrder = await FirebaseDatabase.instance
        .ref("orders")
        .orderByChild('status')
        .equalTo(true);

    await myOrder.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? dataOrder = child.value as Map?;

        final Query myOrderItem = await FirebaseDatabase.instance
            .ref("orderItem")
            .orderByChild('orderID')
            .equalTo(dataOrder?["orderID"]);
        await myOrderItem.onValue.listen((event) async {
          for (final child1 in event.snapshot.children) {
            final Map<dynamic, dynamic>? data = child1.value as Map?;
            final Query productSizeColor = await FirebaseDatabase.instance
                .ref("ProductSizeColor")
                .orderByChild('ProductID')
                .equalTo(pid);
            int k = 0;
            await productSizeColor.onValue.listen((event) async {
              for (final child2 in event.snapshot.children) {
                final Map<dynamic, dynamic>? dataProductSizeColor =
                child2.value as Map?;
                // print(data?['productID']);
                // print(dataProductSizeColor?['ProductID']);
                // print(dataProductSizeColor?['SizeID']);
                // print(dataProductSizeColor?['SizeID']);
                // print(data?['productColor']);
                // print(dataProductSizeColor?['ColorID']);

                String getSize =
                await getNameById(dataProductSizeColor?['SizeID'], 'Size');
                String getColor = await getNameById(
                    dataProductSizeColor?['ColorID'], 'Color');
                if (k < productSizeColorlist!.length &&
                    data?['productID'] == dataProductSizeColor?['ProductID'] &&
                    data?['productSize'] == getSize &&
                    data?['productColor'] == getColor) {
                  // print(dataProductSizeColor?['ProductID']);
                  // print(_productSizeColorlist?[k].productID);
                  // print(getSize);
                  // print(_productSizeColorlist?[k].sizeID);
                  // print(getColor);
                  // print(_productSizeColorlist?[k].colorID);
                  int subtotal = await data?['subTotal'] ?? 0;
                  int quantity = await data?['quantity'] ?? 0;
                  _productSizeColorlist?[k].price =
                  await ((_productSizeColorlist?[k].price)! +
                      subtotal * quantity)!;
                  print(_productSizeColorlist?[k].price);
                }
                await k++;
              }
            });
          }
        });
      }
    });
  }

  Future getProductSizeColorRevenueByTime(String DateStart, String DateEnd,
      String? pid) async {
    DateTime ds = DateFormat("dd/MM/yyyy").parse(DateStart);
    DateTime de = DateFormat("dd/MM/yyyy").parse(DateEnd);
    // for (int i = 0; i < _productSizeColorlist!.length; i++) {
    //   _productSizeColorlist?[i].price = 0;
    // }

    final Query myOrder = await FirebaseDatabase.instance
        .ref("orders")
        .orderByChild('status')
        .equalTo(true);

    await myOrder.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        final Map<dynamic, dynamic>? dataOrder = child.value as Map?;

        final Query myOrderItem = await FirebaseDatabase.instance
            .ref("orderItem")
            .orderByChild('orderID')
            .equalTo(dataOrder?["orderID"]);
        await myOrderItem.onValue.listen((event) async {
          for (final child1 in event.snapshot.children) {
            final Map<dynamic, dynamic>? data = child1.value as Map?;
            List<String>? date = data?['orderDate'].toString().split(" ");
            DateTime d = DateFormat("yyyy-MM-dd").parse(date![0]);

            if ((d.isAfter(ds) || d.isAtSameMomentAs(ds)) &&
                (d.isBefore(de) || d.isAtSameMomentAs(de))) {
              final Query productSizeColor = await FirebaseDatabase.instance
                  .ref("ProductSizeColor")
                  .orderByChild('ProductID')
                  .equalTo(pid);
              int k = 0;
              await productSizeColor.onValue.listen((event) async {
                for (final child2 in event.snapshot.children) {
                  final Map<dynamic, dynamic>? dataProductSizeColor =
                  child2.value as Map?;
                  // print(data?['productID']);
                  // print(dataProductSizeColor?['ProductID']);
                  // print(dataProductSizeColor?['SizeID']);
                  // print(dataProductSizeColor?['SizeID']);
                  // print(data?['productColor']);
                  // print(dataProductSizeColor?['ColorID']);

                  String getSize = await getNameById(
                      dataProductSizeColor?['SizeID'], 'Size');
                  String getColor = await getNameById(
                      dataProductSizeColor?['ColorID'], 'Color');
                  if (k < productSizeColorlist!.length &&
                      data?['productID'] ==
                          dataProductSizeColor?['ProductID'] &&
                      data?['productSize'] == getSize &&
                      data?['productColor'] == getColor) {
                    // print(dataProductSizeColor?['ProductID']);
                    // print(_productSizeColorlist?[k].productID);
                    // print(getSize);
                    // print(_productSizeColorlist?[k].sizeID);
                    // print(getColor);
                    // print(_productSizeColorlist?[k].colorID);
                    int subtotal = await data?['subTotal'] ?? 0;
                    int quantity = await data?['quantity'] ?? 0;
                    _productSizeColorlist?[k].price =
                    await ((_productSizeColorlist?[k].price)! +
                        subtotal * quantity)!;
                    print(_productSizeColorlist?[k].price);
                  }
                  await k++;
                }
              });
            }
          }
        });
      }
    });

    // final DatabaseReference myOrderItem =
    //     await FirebaseDatabase.instance.ref("orderItem");
    //
    // final DatabaseReference myOrder =
    //     await FirebaseDatabase.instance.ref("orders");
    //
    // await myOrder.onValue.listen((event) async {
    //   for (final child in event.snapshot.children) {
    //     final Map<dynamic, dynamic>? dataOrder = child.value as Map?;
    //     if (dataOrder?["status"] == true) {
    //       await myOrderItem.onValue.listen((event) async {
    //         for (final child1 in event.snapshot.children) {
    //           final Map<dynamic, dynamic>? data = child1.value as Map?;
    //           if (data?["orderID"] == dataOrder?["orderID"]) {
    //             List<String>? date = data?['orderDate'].toString().split(" ");
    //             DateTime d = DateFormat("yyyy-MM-dd").parse(date![0]);
    //
    //             if ((d.isAfter(ds) || d.isAtSameMomentAs(ds)) &&
    //                 (d.isBefore(de) || d.isAtSameMomentAs(de))) {
    //               print("đã vô");
    //
    //               for (int j = 0; j < _productSizeColorlist!.length; j++) {
    //                 //Nếu như trùng với biến thể của OrderItem thì thêm vào và đồng thời cộng số tiền doanh thu lên
    //                 if (_productSizeColorlist?[j].productID ==
    //                         data?['productID'] &&
    //                     _productSizeColorlist?[j].colorID ==
    //                         data?['productColor'] &&
    //                     _productSizeColorlist?[j].sizeID ==
    //                         data?['productSize']) {
    //                   _productSizeColorlist?[j].price =
    //                       await ((_productSizeColorlist?[j].price ?? 0) +
    //                           (data?['subTotal'] ?? 0)) as int?;
    //                   print(_productSizeColorlist?[j].price);
    //                 }
    //               }
    //             }
    //           }
    //         }
    //       });
    //     }
    //   }
    // });
  }
}
