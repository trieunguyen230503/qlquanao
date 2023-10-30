import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../model/Order.dart';
import 'ApprovedInfo.dart';

class ApprovedPage extends StatefulWidget {
  const ApprovedPage({super.key});

  @override
  State<ApprovedPage> createState() => _ApprovedPageState();
}

class _ApprovedPageState extends State<ApprovedPage> {
  List<Orders> orderList = [];
  int codeOrder = 0;

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
    Widget myWidget;

    if (orderList.isEmpty) {
      myWidget = Center(child: Text("Không có đơn nào!"));
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
                height: 150,
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
                            formatPrice(orderItem.totalamount!) + "đ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        (orderItem.userName!.length > 20)
                            ? '${orderItem.userName!.substring(0, 20)}...' // Hiển thị 'text...' nếu độ dài vượt quá length
                            : "Tên KH: " + orderItem.userName!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black38,
                        ),
                      ),
                      Text(
                        "Địa chỉ: " + orderItem!.address.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black38,
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
