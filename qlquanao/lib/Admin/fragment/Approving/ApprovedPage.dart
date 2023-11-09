import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/Order.dart';
import 'ApprovedInfo.dart';

class ApprovedPage extends StatefulWidget {
  const ApprovedPage({super.key});

  @override
  State<ApprovedPage> createState() => _ApprovedPageState();
}

class _ApprovedPageState extends State<ApprovedPage> {
  List<Orders> orderList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrdersFromFirebase();
  }

  void getOrdersFromFirebase() async {
    // Khởi tạo tham chiếu đến cơ sở dữ liệu Firebase
    final DatabaseReference databaseRef =
        FirebaseDatabase.instance.ref("orders");
    // final DatabaseReference refCodeOrder = FirebaseDatabase.instance.ref().child('codeOrder/code');

    await databaseRef.onValue.listen((event) {
      if (orderList.isNotEmpty) {
        orderList.clear();
      }

      for (final child in event.snapshot.children) {
        Orders orders = Orders.fromSnapshot(child);
        if (orders.status == true) {
          orderList.add(orders);
        }
      }
      setState(() {
        orderList = orderList.reversed.toList();
      });
    }, onError: (error) {
      // Error.
    });
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyFormatterUSD = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    Widget myWidget;

    if (orderList.isEmpty) {
      myWidget = Center(child: Text("There are no orders!"));
    } else {
      myWidget = ListView.builder(
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            final orderItem = orderList[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ApprovedInfo(order: orderList[index])));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          Text(
                            currencyFormatterUSD.format(orderItem.totalamount!),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          (orderItem.userName!.length > 20)
                              ? '${orderItem.userName!.substring(0, 20)}...' // Hiển thị 'text...' nếu độ dài vượt quá length
                              : "Customer: " + orderItem.userName!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Address: " + orderItem!.address.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                      if(orderItem.payment == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 10, right: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              Text("Paid by ",
                                style: TextStyle(fontSize: 15, color: Colors.black),
                              ),
                              Image.asset("assets/paypal_logo.png", width: 50, height: 30),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return Scaffold(
      body: Container(child: myWidget),
    );
  }
}
