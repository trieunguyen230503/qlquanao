import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qlquanao/model/OrderItem.dart';

import '../../model/Order.dart';

String formatPrice(int price) {
  final formatter = NumberFormat("#,###");
  return formatter.format(price);
}

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  List<Orders> orderList = [];

  @override
  void initState() {
    super.initState();
    getOrdersFromFirebase();
  }

  void getOrdersFromFirebase() async {
    final DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref("orders");

    databaseRef.onValue.listen((event) {
      if (orderList.isNotEmpty) {
        orderList.clear();
      }

      for (final child in event.snapshot.children) {
        Orders orders = Orders.fromSnapshot(child);
        orderList.add(orders);
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

    await databaseRef.onValue.listen((event) {
      for (final child in event.snapshot.children) {
        OrderItem orderItem = OrderItem.fromSnapshot(child);
        if (orderItem.orderID == orderID) {
          orderItems.add(orderItem);
        }
      }
    }, onError: (error) {
      // Error.
    });

    return orderItems;
  }

  @override
  Widget build(BuildContext context) {
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
                                                formatPrice(listProductItem[i]
                                                        .subTotal!) +
                                                    "đ",
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
                                Text("Total: " + formatPrice(orderItem.totalamount!) + "đ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),),
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
