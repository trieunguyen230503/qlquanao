import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qlquanao/model/OrderItem.dart';

import '../../model/Order.dart';
import '../../provider/signin_provider.dart';


class OrderHistory{
  Orders? orders;
  List<OrderItem>? orderItems;
}


class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Orders> orderList = [];
  List<OrderHistory> orderHistoryList = [];
  String? uid;


  @override
  void initState() {
    super.initState();
    getDataUser();
    getOrdersFromFirebase();
  }


  void getDataUser() async {
    // Lấy id user đang đăng nhập
    final sp = context.read<SignInProvider>();
    await sp.getDataFromSharedPreference();
    uid = sp.uid;
  }


  void getOrdersFromFirebase() async {
    final DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref("orders");

    databaseRef.onValue.listen((event) async {
      if (orderList.isNotEmpty) {
        orderList.clear();
      }

      for (final child in event.snapshot.children) {
        Orders orders = Orders.fromSnapshot(child);
        if(orders.userID == uid){
          orderList.add(orders);
        }
      }
      if (!mounted) {
        return;
      }
      setState(() {
        orderList = orderList.reversed.toList();
      });
    }, onError: (error) {
      // Error.
    });
  }

  // Function to fetch a list of OrderItems for a specific order
  Future<List<OrderItem>> fetchOrderItemsForOrder(String orderID) async {
    final DatabaseReference databaseRef =
    FirebaseDatabase.instance.ref("orderItem");
    List<OrderItem> orderItems = [];

    // Sử dụng Completer để giữ track khi sự kiện lắng nghe hoàn thành
    Completer<List<OrderItem>> completer = Completer<List<OrderItem>>();

    // Lắng nghe sự kiện onValue từ databaseRef
    databaseRef.onValue.listen((event) {
      for (final child in event.snapshot.children) {
        OrderItem orderItem = OrderItem.fromSnapshot(child);
        if (orderItem.orderID == orderID) {
          orderItems.add(orderItem);
          print("Đã add 1");
        }
      }

      // Khi sự kiện lắng nghe hoàn thành, hoặc có thể đặt điều kiện nếu cần
      completer.complete(orderItems);
    }, onError: (error) {
      // Xử lý lỗi nếu có
      completer.completeError(error);
    });

    // Trả về Future từ Completer
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormatterUSD = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        automaticallyImplyLeading: true,
        title: Text(
          'ORDER HISTORY',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: (orderList.isEmpty)
          ? Center(child: Text("There are no orders!"))
          : ListView.builder(
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                final orderItem = orderList[index];
                return FutureBuilder(
                  future: fetchOrderItemsForOrder(orderItem.orderID!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    // } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    //   return Text("No products for this order");
                    } else {
                      List<OrderItem> listProductItem =
                          snapshot.data as List<OrderItem>;
                      return InkWell(
                        onTap: () {
                          // Handle order item tap if needed
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      orderItem.oderDate.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      (orderItem.status == true)
                                          ? "Done"
                                          : "Waiting...",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                for (int i = 0; i < listProductItem.length; i++)
                                  Container(
                                    height: 110,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 5),
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
                                          child: Image.network(
                                              listProductItem[i].image!),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                (listProductItem[i].productName!.length > 12)
                                                    ? '${listProductItem[i].productName!.substring(0, 12)}...' // Hiển thị 'text...' nếu độ dài vượt quá length
                                                    : listProductItem[i].productName!,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                listProductItem[i]
                                                        .productColor! +
                                                    ", " +
                                                    listProductItem[i]
                                                        .productSize!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF4C53A5),
                                                ),
                                              ),
                                              Text(
                                                currencyFormatterUSD.format(listProductItem[i]
                                                        .subTotal!),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            "x" +
                                                listProductItem[i]
                                                    .quantity
                                                    .toString()
                                                    .trim(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Text("Total: " + currencyFormatterUSD.format(orderItem.totalamount!), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF000099)),),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
