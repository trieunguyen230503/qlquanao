import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qlquanao/Admin/fragment/Approving/adminApproveOrder.dart';
import 'package:qlquanao/model/Order.dart';
import 'package:qlquanao/model/OrderItem.dart';

import '../../../model/ProductSizeColor.dart';


class ApprovingInfo extends StatefulWidget {
  final Orders order;
  ApprovingInfo({required this.order});

  @override
  State<ApprovingInfo> createState() => _ApprovingInfoState(order: order);
}

class _ApprovingInfoState extends State<ApprovingInfo> {
  final Orders order;

  _ApprovingInfoState({required this.order});

  ScrollController _scrollController = ScrollController();
  final List<OrderItem> listOrderItem = [];
  String orderID = "";
  int totalAmount = 0;

  List<ProductSizeColorData> listProductSizeColor = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderItemFromFirebase();
    getProductSizeColorFromFirebase();
  }

  void getOrderItemFromFirebase() async {
    if (order.orderID != null) {
      orderID = order.orderID!;
      totalAmount = 0;
    }

    // Khởi tạo tham chiếu đến cơ sở dữ liệu Firebase
    final DatabaseReference databaseRef = FirebaseDatabase.instance.ref("orderItem");

    await databaseRef.onValue.listen((event) {
      if (listOrderItem.isNotEmpty) {
        listOrderItem.clear();
      }

      for (final child in event.snapshot.children) {
        String id = child.child("orderID").value.toString();

        if (orderID == id) {
          OrderItem orderItem = OrderItem.fromSnapshot(child);
          setState(() {
            listOrderItem.add(orderItem);
            totalAmount += orderItem.subTotal! * orderItem.quantity!;
          });
        }
      }
    }, onError: (error) {
      // Error.
    });
  }

  void getProductSizeColorFromFirebase() async {
    final DatabaseReference databaseRef =
    FirebaseDatabase.instance.ref("ProductSizeColor");

    databaseRef.onValue.listen((event) {
      if (listProductSizeColor.isNotEmpty) {
        listProductSizeColor.clear();
      }
      if(!mounted)
        return;

      for (final snap in event.snapshot.children) {
        ProductSizeColorData p = ProductSizeColorData.fromSnapshot(snap);
        listProductSizeColor.add(p);
      }
      onError:(error) {
        // Error.
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormatterUSD = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 18,
                        ),
                      ),
                      Text(
                        "Customer information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      "Name: " + order.userName! + "  |  Phone: " + order.phone!,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 6, right: 15),
                    child: Text(
                      "Address: " + order.address!,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey, // Đổi màu đường gạch thành đỏ
              thickness: 1, // Độ dày của đường gạch
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 15),
              child: Text(
                "List of products",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 8,
                radius: Radius.circular(10),
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: listOrderItem.length,
                  itemBuilder: (context, index) {
                    final item = listOrderItem[index];
                    return Container(
                      height: 170,
                      margin: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            margin: EdgeInsets.only(right: 10),
                            child: Image.network(item.image!),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.productName!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Color: " + item.productColor! + ",     " + "Size: " + item.productSize!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      currencyFormatterUSD.format(item.subTotal!),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "              Quantity: " +
                                          item.quantity.toString().trim(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Quantity in stock: 1" , // Nhớ + 1 nếu đã trừ lúc khách hàng đặt hàng, khi từ chối duyệt thì +1 lại trong database
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                children: [
                  Text(
                    "Total Amount: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Text(
                    currencyFormatterUSD.format(totalAmount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () => updateStatus(false, context),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(120, 40)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.red),
                      side: MaterialStateProperty.all(BorderSide(color: Colors.red)),
                    ),
                    child: Text("Refuse",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => updateStatus(true, context),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(120, 40)),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.green),
                      side: MaterialStateProperty.all(BorderSide(color: Colors.green)),
                    ),
                    child: Text("Agree",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateStatus(bool action, BuildContext context) async {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.ref('orders');
    if(action == true){
      databaseReference.child(orderID).child('status').ref.set(true);

      await Fluttertoast.showToast(
          msg: "Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ApproveOrderPage()));
    }
    else{
      databaseReference.child(orderID).ref.remove();
      await Fluttertoast.showToast(
          msg: "Refused",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
      for(var item in listOrderItem){
        await _updateQuantity(item);
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => ApproveOrderPage()));
    }
  }

  Future<void> _updateQuantity(OrderItem product) async {
    final DatabaseReference databaseRef =
    FirebaseDatabase.instance.ref("ProductSizeColor");

    String? idColor = await getColorID(product.productColor!);
    String? idSize = await getSizeID(product.productSize!);

    for(var item in listProductSizeColor){
      String productID = item.productID.toString();
      if (productID == product.productID) {
        String size = item.sizeID.toString();
        String color = item.colorID.toString();
        String id  = item.uid.toString();

        // print("size: " + size + "   " + "color: " + color);
        // print("idSize: " + idSize.toString() + "   " + "idColor: " + idColor.toString());

        if(size == idSize && color == idColor){
          print("id: " + id.toString());
          ProductSizeColorData p = ProductSizeColorData(
            uid: item.uid,
            productID: item.productID,
            sizeID: item.sizeID,
            colorID: item.colorID,
            price: item.price,
            quantity: item.quantity! + product.quantity!,
            url: item.url,
          );
          databaseRef.child(id).set(p.toJson());
        }
      }
    }
  }

  Future<String?> getColorID(String colorName) async {
    String? color;
    try {
      final recentPostsRef = await FirebaseDatabase.instance.ref('Color').orderByChild('Name').equalTo(colorName).once();
      DataSnapshot snapshot = recentPostsRef.snapshot;
      if (snapshot.value != null) {
        color = snapshot.children.first.key.toString();
      } else {
        print("No color data found");
      }
      return color;
    } catch (error) {
      print("Error: $error");
      return color;
    }
  }

  Future<String?> getSizeID(String sizeName) async {
    String? size;
    try {
      final recentPostsRef = await FirebaseDatabase.instance.ref('Size').orderByChild('Name').equalTo(sizeName).once();
      DataSnapshot snapshot = recentPostsRef.snapshot;
      if (snapshot.value != null) {
        size = snapshot.children.first.key.toString();
      } else {
        print("No color data found");
      }
      return size;
    } catch (error) {
      print("Error: $error");
      return size;
    }
  }
}
